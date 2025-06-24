package com.example.service;

import com.example.dto.AnswerDto;
import com.example.dto.EstimateHoursRequest;
import com.example.dto.EstimateHoursResponse;
import com.example.dto.QuestionDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;
import java.util.function.Function;

@Service
public class EstimationService {

    private static final Logger logger = LoggerFactory.getLogger(EstimationService.class);

    private final SimpleLLMService llmService;
    private final ObjectMapper objectMapper;

    // コンストラクタを更新
    public EstimationService(SimpleLLMService llmService, ObjectMapper objectMapper) {
        this.llmService = llmService;
        this.objectMapper = objectMapper;
    }

    /**
     * ユーザーの目標と回答に基づき、AIを用いて必要時間を算出します。
     */
    public EstimateHoursResponse estimateHours(EstimateHoursRequest request) {
        logger.info("必要時間の算出を開始します。Goal: {}", request.getGoal());

        // 1. AIに渡すためのプロンプトを生成
        String prompt = createPromptForEstimation(request);

        // 2. AIサービスを呼び出し、JSON形式の応答を取得
        String rawResponse = llmService.askLLM(prompt);
        String jsonResponse = cleanAiResponse(rawResponse);
        logger.debug("AIからの整形済みレスポンス: {}", jsonResponse);

        try {
            // 3. AIからのJSON文字列を直接 `EstimateHoursResponse` DTOにマッピング
            return objectMapper.readValue(jsonResponse, EstimateHoursResponse.class);
        } catch (JsonProcessingException e) {
            logger.error("AIからのJSONレスポンスのパースに失敗しました。Response: {}", jsonResponse, e);
            throw new RuntimeException("AIからの応答（必要時間）の処理に失敗しました。", e);
        }
    }

    /**
     * 必要時間算出のためにAIに渡すプロンプトを生成します。
     */
    private String createPromptForEstimation(EstimateHoursRequest request) {
        List<QuestionDto> questions = request.getQuestions();
        List<AnswerDto> answers = request.getAnswers();
        StringBuilder answersTextBuilder = new StringBuilder();

        // 質問と回答をインデックスで紐付ける
        // 念のため、リストのサイズが小さい方に合わせる
        int size = Math.min(questions.size(), answers.size());
        for (int i = 0; i < size; i++) {
            String questionText = questions.get(i).getQuestion();
            String answerValue = answers.get(i).getAnswer();
            answersTextBuilder.append(String.format("質問: %s\n回答: %s", questionText, answerValue));
            if (i < size - 1) {
                answersTextBuilder.append("\n---\n");
            }
        }
        String answersText = answersTextBuilder.toString();


        return String.format("""
    あなたは、ユーザーのスキルレベルや目標に基づき、学習に必要な時間を推定する専門家です。

    # ユーザーの最終目標
    %s

    # ユーザーの自己申告（ヒアリング結果）
    %s

    # あなたのタスク
    上記の最終目標とヒアリング結果を総合的に分析し、目標達成までに必要だと考えられる学習時間の範囲（最小時間と最大時間）と、そのように判断した理由を専門家としてコメントしてください。時間は必ず整数値で返してください。

    # 出力形式
    以下のJSON形式で、他のテキストは一切含めないでください。
    {
      "minHours": (最小学習時間 int),
      "maxHours": (最大学習時間 int),
      "comment": "(推定の根拠やアドバイス string)"
    }
    """, request.getGoal(), answersText);
    }
    
    /**
     * AIからの応答文字列を整形し、JSONパースしやすいようにします。
     */
    private String cleanAiResponse(String response) {
        // (このメソッドの実装は変更なし)
        if (response == null) { return ""; }
        String cleaned = response.trim();
        if (cleaned.startsWith("```json")) { cleaned = cleaned.substring(7); }
        else if (cleaned.startsWith("```")) { cleaned = cleaned.substring(3); }
        if (cleaned.endsWith("```")) { cleaned = cleaned.substring(0, cleaned.length() - 3); }
        return cleaned.trim();
    }
}
