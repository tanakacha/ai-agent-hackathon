package com.example.service;

import com.example.dto.RoadmapDocument;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

/**
 * 新しいデータ構造であるRoadmapDocumentの永続化（Firestoreへの保存・取得など）を管理するサービス。
 */
@Service
public class RoadmapDocumentService {

    private static final Logger logger = LoggerFactory.getLogger(RoadmapDocumentService.class);
    private final Firestore firestore;

    private static final String ROADMAPS_COLLECTION = "maps";

    public RoadmapDocumentService(Firestore firestore) {
        this.firestore = firestore;
    }

    /**
     * RoadmapDocument全体をFirestoreに保存または上書きするメソッド。
     * @param roadmapDocument 保存する完全なロードマップオブジェクト
     * @return 保存されたRoadmapDocumentオブジェクト
     */
    public RoadmapDocument save(RoadmapDocument roadmapDocument) throws ExecutionException, InterruptedException {
        String documentId = roadmapDocument.getId();
        if (documentId == null || documentId.isEmpty()) {
            throw new IllegalArgumentException("RoadmapDocument must have a non-empty ID.");
        }
        
        logger.info("開始: RoadmapDocumentの保存 (ID: {})", documentId);

        DocumentReference docRef = firestore.collection(ROADMAPS_COLLECTION).document(documentId);
        
        ApiFuture<WriteResult> future = docRef.set(roadmapDocument);
        
        WriteResult result = future.get();
        logger.info("完了: RoadmapDocumentの保存 (ID: {}), 更新時刻={}", documentId, result.getUpdateTime());
        
        return roadmapDocument;
    }

    /**
     * IDを指定して、単一のRoadmapDocumentをFirestoreから取得するメソッド。
     * @param roadmapId 取得したいロードマップのID
     * @return 見つかったRoadmapDocumentオブジェクト。存在しない場合はnullを返す。
     */
    public RoadmapDocument findById(String roadmapId) throws ExecutionException, InterruptedException {
        logger.info("開始: RoadmapDocumentの取得 (ID: {})", roadmapId);
        
        DocumentReference docRef = firestore.collection(ROADMAPS_COLLECTION).document(roadmapId);
        ApiFuture<DocumentSnapshot> future = docRef.get();
        DocumentSnapshot document = future.get();

        if (document.exists()) {
            RoadmapDocument roadmap = document.toObject(RoadmapDocument.class);
            logger.info("完了: RoadmapDocumentの取得成功 (ID: {})", roadmapId);
            return roadmap;
        } else {
            logger.warn("ドキュメントが見つかりませんでした: {}", roadmapId);
            return null;
        }
    }

    // 将来的には、更新(update)や削除(delete)のメソッドもここに追加していく
}
