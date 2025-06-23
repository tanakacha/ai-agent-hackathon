package com.example.repository;

import com.example.dto.RoadmapDocument;
import com.google.cloud.firestore.Firestore;
import org.springframework.stereotype.Repository;
import java.util.concurrent.ExecutionException;

@Repository
public class RoadmapRepository {
    private static final String COLLECTION_NAME = "roadmaps";
    private final Firestore firestore;

    public RoadmapRepository(Firestore firestore) { this.firestore = firestore; }

    public RoadmapDocument save(RoadmapDocument roadmap) {
        try {
            firestore.collection(COLLECTION_NAME).document(roadmap.getId()).set(roadmap).get();
            return roadmap;
        } catch (InterruptedException | ExecutionException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("RoadmapDocumentの保存に失敗しました: " + roadmap.getId(), e);
        }
    }
}
