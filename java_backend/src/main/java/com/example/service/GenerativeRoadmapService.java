package com.example.service;

import com.example.dto.*;
import com.example.repository.NodeRepository;
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
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;
import java.util.function.Function;

@Service
public class GenerativeRoadmapService {

    private static final Logger logger = LoggerFactory.getLogger(GenerativeRoadmapService.class);

    private final SimpleLLMService llmService;
    private final RoadmapRepository roadmapRepository;
    private final NodeRepository nodeRepository; // Node保存用に必須
    private final ObjectMapper objectMapper;

    private static class LlmRoadmapResponse {
        public String roadmapTitle;
        public List<Node> nodes;
    }

    public GenerativeRoadmapService(SimpleLLMService llmService, 
                          RoadmapRepository roadmapRepository, NodeRepository nodeRepository, ObjectMapper objectMapper) {
        this.llmService = llmService;
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
            String prompt = createPromptForRoadmap(request);
            String jsonResponse = cleanAiResponse(llmService.askLLM(prompt));
            LlmRoadmapResponse llmResponse = objectMapper.readValue(jsonResponse, LlmRoadmapResponse.class);

            String roadmapIdStr = UUID.randomUUID().toString().substring(0, 8);
            String mapId = "map-" + roadmapIdStr;
            

            List<Node> taskNodes = structureTaskNodes(llmResponse.nodes, roadmapIdStr, mapId);
            Node rootNode = createSpecialNode(roadmapIdStr, mapId, "root", "root", "root_description");
            Node startNode = createSpecialNode(roadmapIdStr, mapId, "start", "start", "開始！");
            Node goalNode = createSpecialNode(roadmapIdStr, mapId, "goal", "goal", "終了！");

            List<Node> allNodes = new ArrayList<>();
            allNodes.add(rootNode);
            allNodes.add(startNode);
            allNodes.addAll(taskNodes);
            allNodes.add(goalNode);
            

            nodeRepository.saveAll(allNodes);
            logger.info("{}個のNodeをDBに保存しました。", allNodes.size());

            RoadmapDocument roadmapToSave = buildRoadmapDocument(request, userId, llmResponse.roadmapTitle, allNodes, mapId);
            roadmapRepository.save(roadmapToSave);
            logger.info("RoadmapDocumentをDBに保存しました。ID: {}", roadmapToSave.getId());

            return new RoadmapCreationResponseDto(roadmapToSave, allNodes);

        } catch (Exception e) {
            logger.error("ロードマップ生成の予期せぬエラー。", e);
            throw new RuntimeException("ロードマップ生成中にエラーが発生しました。", e);
        }
    }

    private RoadmapDocument buildRoadmapDocument(CreateRoadmapRequest request, String userId, String title, List<Node> nodes, String mapId) {
        RoadmapDocument doc = new RoadmapDocument();
        Instant now = Instant.now();

        doc.setId(mapId);
        doc.setUserId(userId);
        doc.setCreatedAt(now);
        doc.setUpdatedAt(now);
        doc.setGoal(request.getGoal());
        doc.setTotalEstimatedHours(request.getTotalEstimatedHours());

        doc.setQaPairs(request.getQaPairs());
        List<String> nodeIds = nodes.stream().map(Node::getId).collect(Collectors.toList());
        doc.setNodeId(nodeIds);
        
        return doc;
    }
    
    private List<Node> structureTaskNodes(List<Node> simpleNodes, String roadmapIdStr, String mapId) {
        if (simpleNodes == null || simpleNodes.isEmpty()) return List.of();
        Date now = new Date();
        int sequence = 1;
        for (Node node : simpleNodes) {
            node.setId("node-" + roadmapIdStr + "-" + sequence++);
            node.setNode_type("Task");
            node.setProgress_rate(0);
            node.setCreated_at(now);
            node.setUpdated_at(now);
            node.setMap_id(mapId);
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
        String answersText = request.getQaPairs().stream()
            .map(pair -> String.format("質問: %s\n回答: %s", pair.getQuestion(), pair.getAnswer()))
            .collect(Collectors.joining("\n---\n"));



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
                  "duration": (ステップ2の_所要時間 int)
                }
              ]
            }
            """, request.getGoal(), request.getTotalEstimatedHours(), answersText);
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
        
        String cleaned = response.trim();
        
        if (cleaned.startsWith("```json")) {
            cleaned = cleaned.substring(7);
        } else if (cleaned.startsWith("```")) {
            cleaned = cleaned.substring(3);
        }
        
        if (cleaned.endsWith("```")) {
            cleaned = cleaned.substring(0, cleaned.length() - 3);
        }
        
        return cleaned.trim();
    }

    /**
     * Root, Start, Goal などの特別なノードを生成するためのヘルパーメソッド。
     * @param mapId       ロードマップID ("map-xxxx")
     * @param type        ノードのタイプ兼IDの接尾辞 ("root", "start", "goal")
     * @param title       ノードのタイトル
     * @param description ノードの説明
     * @return 生成されたNodeオブジェクト
     */
    private Node createSpecialNode(String roadmapIdStr, String mapId, String type, String title, String description) {
        Node node = new Node();
        node.setId("node-" + roadmapIdStr + "-" + type);
        node.setMap_id(mapId);
        node.setNode_type(type.substring(0, 1).toUpperCase() + type.substring(1));
        node.setTitle(title);
        node.setDescription(description);
        node.setProgress_rate(0);
        node.setCreated_at(new Date());
        node.setUpdated_at(new Date());
        return node;
    }
}
