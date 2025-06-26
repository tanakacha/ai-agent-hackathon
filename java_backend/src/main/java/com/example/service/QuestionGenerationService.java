package com.example.service;

import com.example.dto.CreateQuestionsRequest;
import com.example.dto.CreateQuestionsResponse;
import com.example.dto.QuestionDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * ユーザーのゴールに基づいて、ロードマップ生成に必要な質問を生成するサービス。
 */
@Service
public class QuestionGenerationService {

    private static final Logger logger = LoggerFactory.getLogger(QuestionGenerationService.class);

    /**
     * ユーザーのゴールに合った質問リストを生成する。
     * @param request ユーザーのゴールを含むリクエスト
     * @return 質問リストと、使用したテンプレートのIDを含むレスポンス
     */
    public CreateQuestionsResponse generateQuestions(CreateQuestionsRequest request) {
        logger.info("質問の生成を開始します。Goal: {}", request.getGoal());

        // TODO: 将来的には、ここでrequest.getGoal()の内容を基にDBやLLMから最適な質問テンプレートを取得する。
        // 現段階では、開発用の固定データを返す。
        
        List<QuestionDto> mockQuestions = createMockWebDevelopmentQuestions();
        String mockTemplateId = "web_development_mock";

        logger.info("テンプレートID '{}' に基づいて、{}個の質問を生成しました。", mockTemplateId, mockQuestions.size());

        return new CreateQuestionsResponse(mockQuestions);
    }

    /**
     * 開発用の固定的な質問リストを生成するプライベートメソッド。
     * @return QuestionDtoのリスト
     */
    private List<QuestionDto> createMockWebDevelopmentQuestions() {
        List<QuestionDto> questions = new ArrayList<>();

        // 質問1: プログラミング経験
        QuestionDto q1 = new QuestionDto();
        q1.setQuestion("あなたのプログラミング経験に最も近いものを選択してください。");
        questions.add(q1);

        // 質問2: HTML/CSSのスキル
        QuestionDto q2 = new QuestionDto();
        q2.setQuestion("HTML/CSSの知識はどのレベルですか？");
        questions.add(q2);

        // 質問3: JavaScriptのスキル
        QuestionDto q3 = new QuestionDto();
        q3.setQuestion("JavaScript（またはTypeScript）の経験について教えてください。");
        questions.add(q3);

        return questions;
    }
}
