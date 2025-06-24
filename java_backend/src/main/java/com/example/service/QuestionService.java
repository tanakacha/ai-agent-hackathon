package com.example.service;

import com.example.dto.CreateQuestionsRequest;
import com.example.dto.CreateQuestionsResponse;
import com.example.dto.QuestionDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * 質問に関するビジネスロジックを処理するサービスクラス。
 */
@Service // このクラスがビジネスロジック層のコンポーネントであることを示す
public class QuestionService {

    private static final Logger logger = LoggerFactory.getLogger(QuestionService.class);

    private final SimpleLLMService llmService;
    private final ObjectMapper objectMapper;

    
    public QuestionService(SimpleLLMService llmService, ObjectMapper objectMapper) {
        this.llmService = llmService;
        this.objectMapper = objectMapper;
    }

    public CreateQuestionsResponse generateQuestions(CreateQuestionsRequest request) {
        logger.info("AIによる質問生成と保存処理を開始します。Goal: {}", request.getGoal());
        
        String prompt = createPromptForQuestionGeneration(request.getGoal());
        String rawResponse = llmService.askLLM(prompt);
        String jsonResponse = cleanAiResponse(rawResponse);
        logger.debug("AIからの整形済みレスポンス: {}", jsonResponse);
        
        try {
            List<QuestionDto> questions = objectMapper.readValue(jsonResponse, new TypeReference<>() {});

            questions.forEach(q -> {
                if (q.getQuestionId() == null || q.getQuestionId().isEmpty()) {
                    q.setQuestionId(UUID.randomUUID().toString());
                }
            });

            logger.info("'{}'という目標に基づき、{}個の質問を生成・保存しました。", request.getGoal(),  questions.size());
            return new CreateQuestionsResponse(questions);

        } catch (JsonProcessingException e) {
            logger.error("AIからのJSONレスポンスのパースに失敗しました。", e);
            throw new RuntimeException("AIからの応答の処理に失敗しました。", e);
        }
    }

    private String createPromptForQuestionGeneration(String goal) {
        return String.format("""
            あなたは、ユーザーの目標達成を支援するための質問を生成するアシスタントです。
            ユーザーの目標は「%s」です。
            この目標を具体化し、達成計画を立てるために必要な5つの質問を考えてください。

            # 制約条件
            - 質問は日本語で生成してください。
            - 回答はJSON配列形式で、他のテキストは含めないでください。
            - 各質問オブジェクトには、以下のキーを含めてください。
              - "text": 質問文 (string)
              - "type": 質問の形式 (string)。"text", "single_choice", "multiple_choice" のいずれか。
              - "options": "single_choice" または "multiple_choice" の場合の選択肢リスト (stringの配列)。"text"の場合は空の配列 `[]` にしてください。
            - "question_id" は含めないでください。

            # 出力形式の例
            [
              {
                "text": "質問文の例1です。",
                "type": "single_choice",
                "options": ["選択肢A", "選択肢B", "選択肢C"]
              },
              {
                "text": "質問文の例2です。",
                "type": "text",
                "options": []
              }
            ]
            """, goal);
    }

    /**
     * AIからの応答文字列を整形し、JSONパースしやすいようにします。
     * @param response AIからの生の応答文字列
     * @return 整形後の文字列
     */
    private String cleanAiResponse(String response) {
        if (response == null) {
            return "";
        }
        // AIが応答を```json ... ```で囲むことがあるため、それを取り除く
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
}
