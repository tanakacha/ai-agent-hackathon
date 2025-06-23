package com.example.ai_hackathon.controller;

import com.example.dto.CreateQuestionsRequest;
import com.example.dto.CreateQuestionsResponse;
import com.example.dto.QuestionDto;
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
     * AIで質問を生成し、DBに保存するためのPOSTエンドポイント。
     * URL: POST http://localhost:8080/api/questions/generate
     */
    @PostMapping("/generate")
    public ResponseEntity<CreateQuestionsResponse> generateQuestions(@RequestBody CreateQuestionsRequest request) {
        logger.info("AI質問生成リクエストを受信しました。Goal: {}", request.getGoal());
        try {
            CreateQuestionsResponse response = questionService.generateAndSaveQuestions(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            logger.error("AIによる質問生成・保存処理中にエラーが発生しました。", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 新しい質問データを手動で作成・保存するためのPOSTエンドポイント。
     * URL: POST http://localhost:8080/api/questions
     */
    @PostMapping
    public ResponseEntity<?> createQuestion(@RequestBody QuestionDto questionDto) {
        logger.info("質問作成リクエストを受信しました。ID: {}", questionDto.getQuestionId());
        try {
            QuestionDto savedQuestion = questionService.createQuestion(questionDto);
            return new ResponseEntity<>(savedQuestion, HttpStatus.CREATED);
        } catch (IllegalArgumentException e) {
            logger.error("質問の作成に失敗しました: " + e.getMessage());
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (RuntimeException e) {
            logger.error("質問の保存中にサーバーエラーが発生しました。ID: {}", questionDto.getQuestionId(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }
    
    /**
     * 指定されたIDの質問を取得するためのGETエンドポイント。
     * URL: GET http://localhost:8080/api/questions/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getQuestionById(@PathVariable String id) {
        logger.info("質問取得リクエストを受信しました。ID: {}", id);
        try {
            QuestionDto questionDto = questionService.getQuestion(id);
            return ResponseEntity.ok(questionDto);
        } catch (RuntimeException e) {
            logger.error("質問の取得に失敗しました。ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
}
