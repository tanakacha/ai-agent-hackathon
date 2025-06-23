// package com.example.service;

// import com.example.dto.AnswerDto;
// import com.example.dto.CreateRoadmapRequest;
// import com.example.dto.QuestionDto;
// import com.fasterxml.jackson.annotation.JsonProperty;
// import com.fasterxml.jackson.databind.ObjectMapper;
// import com.google.cloud.vertexai.api.GenerateContentResponse;
// import com.google.cloud.vertexai.generativeai.ContentMaker;
// import com.google.cloud.vertexai.generativeai.GenerativeModel;
// import lombok.Data;
// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;
// import org.springframework.stereotype.Service;

// import java.util.List;
// import java.util.Map;
// import java.util.stream.Collectors;

// @Service
// public class LlmInteractionService {
//     // (以前の回答で提示したコードと同一です)
//     private static final Logger logger = LoggerFactory.getLogger(LlmInteractionService.class);
//     private final GenerativeModel generativeModel;
//     private final ObjectMapper objectMapper;

//     public LlmInteractionService(GenerativeModel generativeModel, ObjectMapper objectMapper) {
//         this.generativeModel = generativeModel;
//         this.objectMapper = objectMapper;
//     }

//     public LlmResponseDto generateRoadmapAsJson(CreateRoadmapRequest request) throws Exception {
//         logger.info("LLMへのリクエストを生成中... Goal: {}", request.getGoal());
//         String prompt = createAdvancedPrompt(request);
//         logger.debug("生成されたプロンプト:\n{}", prompt);

//         GenerateContentResponse response = generativeModel.generateContent(ContentMaker.fromMultiModalData(prompt));
//         String llmJsonResponse = response.getCandidates(0).getContent().getParts(0).getText();
//         logger.debug("LLMからのJSON応答: {}", llmJsonResponse);

//         return objectMapper.readValue(llmJsonResponse, LlmResponseDto.class);
//     }

//     private String createAdvancedPrompt(CreateRoadmapRequest request) {
//         Map<String, String> questionTextMap = request.getQuestions().stream()
//                 .collect(Collectors.toMap(QuestionDto::getQuestionId, QuestionDto::getText));

//         String answersText = request.getAnswers().stream()
//                 .map(answer -> {
//                     String questionText = questionTextMap.getOrDefault(answer.getQuestionId(), "（不明な質問）");
//                     String answerValue = String.join(", ", answer.getValue());
//                     return String.format("- 質問: %s\n  回答: %s", questionText, answerValue);
//                 })
//                 .collect(Collectors.joining("\n"));

//         return String.format("""
//             あなたは優秀なプロジェクトプランナーです。以下のユーザー情報を基に、詳細な学習ロードマップをJSON形式で作成してください。
//             # ユーザー情報
//             - **最終ゴール**: %s
//             - **ユーザーからの回答(スキル状況)**:
//             %s
//             - **推定総学習時間**: %d時間
//             # 出力要件
//             - ユーザーのスキルレベルや状況を十分に考慮してください。
//             - 全タスクの `duration_hours` の合計が、指定された「推定総学習時間」に近くなるように調整してください。
//             - 応答は必ず以下のJSON形式のみで出力してください。説明文や```json ```マーカーは絶対に含めないでください。
//             {
//               "roadmap_title": "...",
//               "phases": [ { "phase_title": "...", "tasks": [ { "title": "...", "description": "...", "duration_hours": ... } ] } ]
//             }
//             """, request.getGoal(), answersText, request.getTotalEstimatedHours());
//     }

//     @Data
//     public static class LlmResponseDto {
//         @JsonProperty("roadmap_title") private String roadmapTitle;
//         private List<Phase> phases;
//         @Data
//         public static class Phase {
//             @JsonProperty("phase_title") private String phaseTitle;
//             private List<Task> tasks;
//         }
//         @Data
//         public static class Task {
//             private String title;
//             private String description;
//             @JsonProperty("duration_hours") private int durationHours;
//         }
//     }
// }
