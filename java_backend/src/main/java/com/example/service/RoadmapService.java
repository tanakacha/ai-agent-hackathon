package com.example.service;

import com.example.dto.*;
import com.example.repository.NodeRepository;
import com.example.repository.QuestionRepository;
import com.example.repository.RoadmapRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Service
public class RoadmapService {

    private static final Logger logger = LoggerFactory.getLogger(RoadmapService.class);

    private final SimpleLLMService llmService;
    private final QuestionRepository questionRepository;
    private final RoadmapRepository roadmapRepository;
    private final NodeRepository nodeRepository; // Node保存用に必須
    private final ObjectMapper objectMapper;

    // AIからのJSON応答をマッピングするための中間クラス
    private static class LlmRoadmapResponse {
        public String roadmapTitle;
        public List<Node> nodes;
    }

    public RoadmapService(SimpleLLMService llmService, QuestionRepository questionRepository,
                          RoadmapRepository roadmapRepository, NodeRepository nodeRepository, ObjectMapper objectMapper) {
        this.llmService = llmService;
        this.questionRepository = questionRepository;
        this.roadmapRepository = roadmapRepository;
        this.nodeRepository = nodeRepository;
        this.objectMapper = objectMapper;
    }

    /**
     * ロードマップを生成し、関連データをDBに永続化します。
     * @return API応答用のDTO (RoadmapDocumentとNodeリストを含む)
     */
    public RoadmapCreationResponseDto createRoadmap(CreateRoadmapRequest request, String userId) {
        logger.info("正規化モデルでのロードマップ生成処理を開始します。Goal: {}", request.getGoal());

        try {
            // 1. AIでロードマップの骨子（タイトルとシンプルなNodeリスト）を生成
            String prompt = createPromptForRoadmap(request);
            String jsonResponse = cleanAiResponse(llmService.askLLM(prompt));
            LlmRoadmapResponse llmResponse = objectMapper.readValue(jsonResponse, LlmRoadmapResponse.class);

            // 2. AIからのNodeリストに詳細情報（ID、タイムスタンプ等）を付与
            List<Node> structuredNodes = structureNodes(llmResponse.nodes);

            // 3. 【重要】最初にNodeのリストを'nodes'コレクションに保存
            nodeRepository.saveAll(structuredNodes);
            logger.info("{}個のNodeをDBに保存しました。", structuredNodes.size());

            // 4. 次にRoadmapDocumentを構築し、'maps'コレクションに保存
            RoadmapDocument roadmapToSave = buildRoadmapDocument(request, userId, llmResponse.roadmapTitle, structuredNodes);
            roadmapRepository.save(roadmapToSave);
            logger.info("RoadmapDocumentをDBに保存しました。ID: {}", roadmapToSave.getId());

            // 5. Controllerに返すためのレスポンスDTOを構築
            return new RoadmapCreationResponseDto(roadmapToSave, structuredNodes);

        } catch (Exception e) {
            logger.error("ロードマップ生成の予期せぬエラー。", e);
            throw new RuntimeException("ロードマップ生成中にエラーが発生しました。", e);
        }
    }

    /**
     * DBに保存するためのRoadmapDocumentを構築します。
     */
    private RoadmapDocument buildRoadmapDocument(CreateRoadmapRequest request, String userId, String title, List<Node> structuredNodes) {
        RoadmapDocument doc = new RoadmapDocument();
        Instant now = Instant.now();

        doc.setId("map-" + UUID.randomUUID().toString().substring(0, 8));
        doc.setUserId(userId);
        doc.setCreatedAt(now);
        doc.setUpdatedAt(now);
        doc.setGoal(request.getGoal());
        doc.setTotalEstimatedHours(request.getTotalEstimatedHours());

        // CreationContextを構築
        RoadmapDocument.CreationContext context = new RoadmapDocument.CreationContext();
        context.setAnswers(request.getAnswers());
        List<String> questionIds = request.getAnswers().stream().map(AnswerDto::getQuestionId).distinct().collect(Collectors.toList());
        List<QuestionDto> questions = questionIds.stream()
                .map(id -> {
                    try { return questionRepository.findById(id).orElse(null); }
                    catch (Exception e) { logger.error("Question取得失敗 ID:{}", id, e); return null; }
                })
                .filter(java.util.Objects::nonNull).collect(Collectors.toList());
        context.setQuestions(questions);
        doc.setCreationContext(context);
        
        // ★★★ 最も重要な変更点 ★★★
        // 保存するドキュメントには、Node本体ではなく、NodeのIDリストを設定します。
        List<String> nodeIds = structuredNodes.stream().map(Node::getId).collect(Collectors.toList());
        doc.setNodeId(nodeIds);
        
        return doc;
    }
    
    // (structureNodes, createPromptForRoadmap, などの他のヘルパーメソッドは変更ありません)
    // AIが生成したNodeリストに、IDやタイムスタンプ等の詳細情報を付与します。
    private List<Node> structureNodes(List<Node> simpleNodes) {
        if (simpleNodes == null || simpleNodes.isEmpty()) return List.of();
        Date now = new Date();
        for (Node node : simpleNodes) {
            node.setId("node-" + UUID.randomUUID().toString().substring(0, 8));
            node.setNode_type("Task");
            node.setProgress_rate(0);
            node.setCreated_at(now);
            node.setUpdated_at(now);
        }
        return simpleNodes;
    }

    // ロードマップ生成のためのプロンプトを作成します。
    /**
     * ロードマップ生成のためにAIに渡すプロンプトを生成します。
     * AIの役割、入力情報、タスク、そして最も重要な「出力形式」を厳密に指示します。
     *
     * @param request ロードマップ生成に必要な情報（ゴール、総時間、回答）
     * @return AIに送信するための整形済みプロンプト文字列
     */
    private String createPromptForRoadmap(CreateRoadmapRequest request) {
        // ユーザーの全回答を、内部ヘルパーメソッドを使って「質問：回答」の形式に変換
        String answersText = request.getAnswers().stream()
                .map(this::formatAnswerWithQuestionText)
                .collect(Collectors.joining("\n---\n"));

        // String.formatと三重引用符を使って、読みやすく保守しやすいプロンプトを構築
        return String.format("""
            あなたは優秀なメンターであり、学習コンサルタントです。
            以下の情報に基づき、ユーザーが目標を達成するための具体的なステップで構成された学習ロードマップを作成してください。

            # ユーザー情報
            - 最終目標: %s
            - 推定総学習時間: %d時間
            - ユーザーの自己申告（ヒアリング結果）:
            %s

            # あなたのタスク
            1. ユーザーの最終目標を、総学習時間を考慮しながら、複数の具体的な学習ステップ（ノード）に分割してください。
            2. 各ステップには、`title` (簡潔なタイトル), `description` (具体的な説明), `duration` (そのステップの所要時間、単位は時間) を含めてください。
            3. 全ステップの`duration`の合計が、上記の「推定総学習時間」とおおよそ一致するように調整してください。
            4. ロードマップ全体のタイトル `roadmapTitle` も生成してください。
            5. 出力は、以下のJSON形式のみとし、他のテキストは一切含めないでください。

            # 出力形式 (JSONオブジェクト)
            {
              "roadmapTitle": "（ここにロードマップ全体のタイトル）",
              "nodes": [
                {
                  "title": "（ステップ1のタイトル）",
                  "description": "（ステップ1で何をすべきかの具体的な説明）",
                  "duration": (ステップ1の所要時間 int)
                },
                {
                  "title": "（ステップ2のタイトル）",
                  "description": "（ステップ2で何をすべきかの具体的な説明）",
                  "duration": (ステップ2の所要時間 int)
                }
              ]
            }
            """, request.getGoal(), request.getTotalEstimatedHours(), answersText);
    }

    /**
     * AnswerDto（questionIdと回答値）から、質問テキストを含む人間が読みやすいQ&A形式の文字列を生成します。
     * AIに渡すプロンプトの質を高めるために使用します。
     *
     * @param answer ユーザーの回答DTO
     * @return "質問: ... \n回答: ..." 形式の文字列
     */
    private String formatAnswerWithQuestionText(AnswerDto answer) {
        try {
            // questionIdを使ってリポジトリからQuestionDtoを取得
            String questionText = questionRepository.findById(answer.getQuestionId())
                .map(QuestionDto::getText) // QuestionDtoからテキストを取得
                .orElse("不明な質問"); // 万が一DBに見つからなかった場合の代替テキスト

            // 質問と回答を整形して返す
            return String.format(
                "質問: %s\n回答: %s",
                questionText,
                String.join(", ", answer.getValue()) // 回答が複数選択の場合も考慮
            );
        } catch (ExecutionException | InterruptedException e) {
            // DBアクセス中にエラーが発生した場合のフォールバック処理
            Thread.currentThread().interrupt(); // スレッドの割り込みステータスを復元
            logger.error("質問テキストの取得に失敗しました。questionId: {}", answer.getQuestionId(), e);
            // エラーが発生した場合も、ID情報を含めて処理を続行する
            return String.format(
                "質問(ID: %s): [質問テキストの取得に失敗しました]\n回答: %s",
                answer.getQuestionId(),
                String.join(", ", answer.getValue())
            );
        }
    }

    /**
     * AIからの応答文字列を整形し、JSONパースしやすいようにします。
     * LLMが返しがちなマークダウンのコードブロックなどを除去します。
     *
     * @param response AIからの生の応答文字列
     * @return 整形後のJSON文字列
     */
    private String cleanAiResponse(String response) {
        if (response == null) {
            return "";
        }
        
        // 前後の空白を除去
        String cleaned = response.trim();
        
        // ```json ... ``` のようなマークダウン形式を検知して除去
        if (cleaned.startsWith("```json")) {
            cleaned = cleaned.substring(7);
        } else if (cleaned.startsWith("```")) {
            cleaned = cleaned.substring(3);
        }
        
        if (cleaned.endsWith("```")) {
            cleaned = cleaned.substring(0, cleaned.length() - 3);
        }
        
        // 再度、前後の空白を除去して返す
        return cleaned.trim();
    }
}
