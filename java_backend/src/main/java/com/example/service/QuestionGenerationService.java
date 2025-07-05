package com.example.service;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.example.dto.CreateQuestionsRequest;
import com.example.model.Question;
import com.example.model.QuestionType;

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
    public List<Question> generateQuestions(CreateQuestionsRequest request) {
        logger.info("質問の生成を開始します。Goal: {}", request.getGoal());

        // TODO: 将来的には、ここでrequest.getGoal()の内容を基にDBやLLMから最適な質問テンプレートを取得する。
        // 現段階では、開発用の固定データを返す。
        
        List<Question> mockQuestions = createMockWebDevelopmentQuestions();
        String mockTemplateId = "web_development_mock";

        logger.info("テンプレートID '{}' に基づいて、{}個の質問を生成しました。", mockTemplateId, mockQuestions.size());

        return mockQuestions;
    }

    /**
     * 開発用の固定的な質問リストを生成するプライベートメソッド。
     * @return QuestionDtoのリスト
     */
    private List<Question> createMockWebDevelopmentQuestions() {
        List<Question> questions = new ArrayList<>();

        
    questions.add(new Question(
        "q1",
        "あなたのプログラミング経験に最も近いものを選択してください。",
        QuestionType.SINGLE_CHOICE,
        new String[] { "未経験", "少し触ったことがある", "仕事で使用している" }
    ));

    questions.add(new Question(
        "q2",
        "HTML/CSSの知識はどのレベルですか？",
        QuestionType.SINGLE_CHOICE,
        new String[] { "初心者", "中級者", "上級者" }
    ));

    questions.add(new Question(
        "q3",
        "JavaScript（またはTypeScript）の経験について教えてください。",
        QuestionType.SINGLE_CHOICE,
        new String[] { "触ったことがない", "簡単なことはできる", "業務レベルで使っている" }
    ));

        return questions;
    }
}
