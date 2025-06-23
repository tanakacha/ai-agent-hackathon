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
        q1.setQuestionId("wd_q1_prog_exp");
        q1.setText("あなたのプログラミング経験に最も近いものを選択してください。");
        q1.setType("single_choice");
        q1.setOptions(List.of("未経験", "趣味や学校で学んだことがある", "実務経験1年以上"));
        questions.add(q1);

        // 質問2: HTML/CSSのスキル
        QuestionDto q2 = new QuestionDto();
        q2.setQuestionId("wd_q2_html_css");
        q2.setText("HTML/CSSの知識はどのレベルですか？");
        q2.setType("single_choice");
        q2.setOptions(List.of("触ったことがない", "基本的なタグやスタイルが書ける", "レスポンシブデザインも実装できる"));
        questions.add(q2);

        // 質問3: JavaScriptのスキル
        QuestionDto q3 = new QuestionDto();
        q3.setQuestionId("wd_q3_javascript");
        q3.setText("JavaScript（またはTypeScript）の経験について教えてください。");
        q3.setType("single_choice");
        q3.setOptions(List.of("未経験", "基本的な文法を理解している", "非同期処理やフレームワークの利用経験がある"));
        questions.add(q3);

        return questions;
    }
}
