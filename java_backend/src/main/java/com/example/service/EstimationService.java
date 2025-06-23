package com.example.service;

import com.example.dto.AnswerDto;
import com.example.dto.EstimateHoursRequest;
import com.example.dto.EstimateHoursResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * ユーザーの回答に基づき、目標達成に必要な推定時間を算出するサービス。
 */
@Service
public class EstimationService {

    private static final Logger logger = LoggerFactory.getLogger(EstimationService.class);

    /**
     * ユーザーの回答から、推定時間を計算する。
     * @param request テンプレートIDとユーザーの回答リストを含むリクエスト
     * @return 最小・最大の推定時間とコメントを含むレスポンス
     */
    public EstimateHoursResponse estimateHours(EstimateHoursRequest request) {

        // TODO: 将来的には、ここでLLMを呼び出して、より精度の高い推定を行うことも可能。
        // 現段階では、単純なルールベースで計算する。

        // 基本となる学習時間を設定 (例: 200時間)
        int baseHours = 200;
        int adjustment = 0;

        // 回答内容に応じて時間を増減させる
        for (AnswerDto answer : request.getAnswers()) {
            switch (answer.getQuestionId()) {
                case "wd_q1_prog_exp": // プログラミング経験
                    if (answer.getValue().contains("未経験")) {
                        adjustment += 100;
                    } else if (answer.getValue().contains("実務経験1年以上")) {
                        adjustment -= 50;
                    }
                    break;
                
                case "wd_q3_javascript": // JavaScriptの経験
                    if (answer.getValue().contains("未経験")) {
                        adjustment += 80;
                    } else if (answer.getValue().contains("非同期処理やフレームワークの利用経験がある")) {
                        adjustment -= 40;
                    }
                    break;
                
            }
        }
        
        int finalEstimatedHours = Math.max(50, baseHours + adjustment);
        logger.info("計算結果: 最終推定時間 = {}時間 (基本: {}h, 調整: {}h)", finalEstimatedHours, baseHours, adjustment);

        // レスポンスオブジェクトを生成
        EstimateHoursResponse response = new EstimateHoursResponse();
        // 推定時間に幅を持たせる（例: ±20%）
        response.setMinHours((int) (finalEstimatedHours * 0.8));
        response.setMaxHours((int) (finalEstimatedHours * 1.2));
        response.setComment(String.format("あなたのスキルレベルを考慮すると、目標達成にはおよそ%d〜%d時間の学習が必要と見積もられます。", response.getMinHours(), response.getMaxHours()));

        return response;
    }
}
