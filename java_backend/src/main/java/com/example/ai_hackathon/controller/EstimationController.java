package com.example.ai_hackathon.controller;

import com.example.dto.EstimateHoursRequest;
import com.example.dto.EstimateHoursResponse;
import com.example.service.EstimationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 必要時間の算出に関するHTTPリクエストを処理するコントローラ。
 */
@RestController
@RequestMapping("/api/estimations") // このコントローラ内のメソッドは "/api/estimations" でアクセス可能
public class EstimationController {

    private static final Logger logger = LoggerFactory.getLogger(EstimationController.class);

    // ビジネスロジックを担当するサービス
    private final EstimationService estimationService;

    /**
     * コンストラクタインジェクション。
     * SpringがEstimationServiceのインスタンスを自動的に注入します。
     *
     * @param estimationService 必要時間算出のロジックを担当するサービス
     */
    @Autowired
    public EstimationController(EstimationService estimationService) {
        this.estimationService = estimationService;
    }

    /**
     * ユーザーの目標と回答に基づき、必要時間を算出して返すエンドポイント。
     * URL: POST http://localhost:8080/api/estimations
     *
     * @param request ユーザーの目標と回答リストを含むリクエストボディ
     * @return 成功した場合は算出結果(JSON)とHTTPステータス200 OK。
     * エラーの場合はHTTPステータス500 Internal Server Errorを返す。
     */
    @PostMapping
    public ResponseEntity<EstimateHoursResponse> estimateHours(@RequestBody EstimateHoursRequest request) {
        logger.info("必要時間算出リクエストを受信しました。Goal: {}", request.getGoal());
        try {
            // 実際の処理は全てサービス層に委譲
            EstimateHoursResponse response = estimationService.estimateHours(request);

            // 成功レスポンスを返す (HTTP 200 OK)
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            // サービス層で何らかの例外が発生した場合
            logger.error("必要時間の算出中にサーバーエラーが発生しました。", e);
            
            // エラーレスポンスを返す (HTTP 500 Internal Server Error)
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
