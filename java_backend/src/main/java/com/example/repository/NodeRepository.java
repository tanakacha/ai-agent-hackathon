package com.example.repository;

import com.example.dto.Node;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteBatch;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.concurrent.ExecutionException;

@Repository
public class NodeRepository {
    private static final String COLLECTION_NAME = "nodes";
    private final Firestore firestore;

    public NodeRepository(Firestore firestore) { this.firestore = firestore; }

    public List<Node> saveAll(List<Node> nodes) {
        if (nodes == null || nodes.isEmpty()) { return List.of(); }
        try {
            WriteBatch batch = firestore.batch();
            for (Node node : nodes) {
                batch.set(firestore.collection(COLLECTION_NAME).document(node.getId()), node);
            }
            batch.commit().get();
            return nodes;
        } catch (InterruptedException | ExecutionException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("Nodesのバッチ保存に失敗しました。", e);
        }
    }
}
