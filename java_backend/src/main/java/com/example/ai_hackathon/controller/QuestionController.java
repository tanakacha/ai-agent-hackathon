package com.example.ai_hackathon.controller;

import com.example.dto.CreateQuestionsRequest;
import com.example.dto.CreateQuestionsResponse;
import com.example.service.QuestionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/questions")
public class QuestionController {

    private static final Logger logger = LoggerFactory.getLogger(QuestionController.class);
    private final QuestionService questionService;

    @Autowired
    public QuestionController(QuestionService questionService) {
        this.questionService = questionService;
    }

    /**
     * * AIで質問を生成し、DBに保存するためのPOSTエンドポイント。
     * URL: POST http://localhost:8080/api/questions/generate
     */
    @PostMapping("/generate")
    public ResponseEntity<CreateQuestionsResponse> generateQuestions(@RequestBody CreateQuestionsRequest request) {
        logger.info("AI質問生成リクエストを受信しました。Goal: {}", request.getGoal());
        try {
            CreateQuestionsResponse response = questionService.generateQuestions(request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            logger.error("AIによる質問生成処理中にエラーが発生しました。", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
