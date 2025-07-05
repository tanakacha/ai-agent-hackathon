package com.example.service;

import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.example.dto.EstimateHoursRequest;
import com.example.dto.EstimateHoursResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class EstimationService {

    private static final Logger logger = LoggerFactory.getLogger(EstimationService.class);

    private final SimpleLLMService llmService;
    private final ObjectMapper objectMapper;

    public EstimationService(SimpleLLMService llmService, ObjectMapper objectMapper) {
        this.llmService = llmService;
        this.objectMapper = objectMapper;
    }

    public EstimateHoursResponse estimateHours(EstimateHoursRequest request) {
        logger.info("必要時間の算出を開始します。Goal: {}", request.getGoal());

        String prompt = createPromptForEstimation(request);

        String rawResponse = llmService.askLLM(prompt);
        String jsonResponse = cleanAiResponse(rawResponse);
        logger.debug("AIからの整形済みレスポンス: {}", jsonResponse);

        try {
            return objectMapper.readValue(jsonResponse, EstimateHoursResponse.class);
        } catch (JsonProcessingException e) {
            logger.error("AIからのJSONレスポンスのパースに失敗しました。Response: {}", jsonResponse, e);
            throw new RuntimeException("AIからの応答（必要時間）の処理に失敗しました。", e);
        }
    }

   
    private String createPromptForEstimation(EstimateHoursRequest request) {
        String answersText = request.getQaPairs().stream()
            .map(pair -> String.format("質問: %s\n回答: %s", pair.getQuestion(), pair.getAnswer()))
            .collect(Collectors.joining("\n---\n"));

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

    
    
    private String cleanAiResponse(String response) {
        if (response == null) { return ""; }
        String cleaned = response.trim();
        if (cleaned.startsWith("```json")) { cleaned = cleaned.substring(7); }
        else if (cleaned.startsWith("```")) { cleaned = cleaned.substring(3); }
        if (cleaned.endsWith("```")) { cleaned = cleaned.substring(0, cleaned.length() - 3); }
        return cleaned.trim();
    }
}
