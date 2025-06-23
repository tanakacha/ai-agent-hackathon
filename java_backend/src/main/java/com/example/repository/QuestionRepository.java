package com.example.repository; // リポジトリ用のパッケージを作成することを推奨

import com.example.dto.QuestionDto;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.concurrent.ExecutionException;

/**
 * Firestoreの "questions" コレクションに対するデータアクセスを行うリポジトリクラス。
 */
@Repository
public class QuestionRepository {

    private static final Logger logger = LoggerFactory.getLogger(QuestionRepository.class);
    
    // Firestoreのコレクション名を定数として定義
    private static final String COLLECTION_NAME = "questions"; // 実際のコレクション名に合わせてください

    private final Firestore firestore;

    /**
     * コンストラクタ。
     * SpringのDIコンテナがFirestoreのBeanを自動的に注入します。
     * @param firestore Firestoreインスタンス
     */
    public QuestionRepository(Firestore firestore) {
        this.firestore = firestore;
    }

    /**
     * 指定されたIDに対応する質問データをFirestoreから取得します。
     *
     * @param questionId 取得したい質問のドキュメントID
     * @return 質問データを含むOptional。データが存在しない場合は空のOptionalを返す。
     * @throws ExecutionException Firestoreとの通信中に非同期処理で例外が発生した場合
     * @throws InterruptedException 非同期処理の待機が中断された場合
     */
    public Optional<QuestionDto> findById(String questionId) throws ExecutionException, InterruptedException {
        logger.info("Firestoreから質問データを取得します。ID: {}", questionId);

        // 1. 操作対象のドキュメントへの参照を取得
        DocumentReference docRef = firestore.collection(COLLECTION_NAME).document(questionId);

        // 2. ドキュメントを非同期で取得
        ApiFuture<DocumentSnapshot> future = docRef.get();

        // 3. 非同期処理の結果を待機し、ドキュメントスナップショットを取得
        DocumentSnapshot document = future.get();

        // 4. ドキュメントが存在するかチェック
        if (document.exists()) {
            // 5. ドキュメントをQuestionDtoオブジェクトにマッピング
            QuestionDto questionDto = document.toObject(QuestionDto.class);
            logger.info("質問データの取得に成功しました。ID: {}", questionId);
            // 6. Optionalでラップして返す
            return Optional.ofNullable(questionDto);
        } else {
            logger.warn("指定されたIDの質問データが見つかりませんでした。ID: {}", questionId);
            // 7. データが存在しない場合は、空のOptionalを返す
            return Optional.empty();
        }
    }

    /**
     * QuestionDto オブジェクトをFirestoreの "questions" コレクションに保存します。
     * questionId をドキュメントIDとして使用します。
     *
     * @param questionDto 保存するQuestionDtoオブジェクト
     * @return 保存されたQuestionDtoオブジェクト (IDなどを含む)
     * @throws ExecutionException Firestoreとの通信中に非同期処理で例外が発生した場合
     * @throws InterruptedException 非同期処理の待機が中断された場合
     * @throws IllegalArgumentException questionIdがnullまたは空の場合
     */
    public QuestionDto save(QuestionDto questionDto) throws ExecutionException, InterruptedException {
        String questionId = questionDto.getQuestionId(); // QuestionDtoからIDを取得

        if (questionId == null || questionId.isEmpty()) {
            // IDがないドキュメントは保存できないため、エラーを投げる
            throw new IllegalArgumentException("QuestionDto must have a non-empty questionId.");
        }

        // "questions" コレクションの、指定されたIDのドキュメントへの参照を取得
        DocumentReference docRef = firestore.collection(COLLECTION_NAME).document(questionId);

        // .set() メソッドでQuestionDtoオブジェクトをFirestoreに書き込む
        // QuestionDto はPOJOなので、Firestoreが自動でフィールドをマッピングして保存してくれる
        ApiFuture<WriteResult> future = docRef.set(questionDto);

        // 非同期処理の完了を待機し、結果を取得
        WriteResult result = future.get();
        // ログ出力などで保存が完了したことを確認
        logger.info("QuestionDto saved: ID={}, UpdateTime={}", questionId, result.getUpdateTime());

        return questionDto; // 保存したオブジェクトを返す
    }
}
