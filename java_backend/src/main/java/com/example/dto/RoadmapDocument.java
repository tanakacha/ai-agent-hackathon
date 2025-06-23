package com.example.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.Instant;
import java.util.List;

/**
 * Firestoreの 'roadmaps' コレクションに保存されるドキュメント全体を表すデータモデル。
 */
@Data
@NoArgsConstructor
public class RoadmapDocument {

    // --- メタデータ ---
    private String id; // FirestoreのドキュメントID (例: map-xxxx)
    private String userId;
    private Instant createdAt;
    private Instant updatedAt;

    // --- ロードマップ生成時のインプット情報 ---
    private String goal;
    private int totalEstimatedHours;
    private CreationContext creationContext;

    // --- 生成されたロードマップ本体---
    private List<Node> nodes;

    @Data
    @NoArgsConstructor
    public static class CreationContext {
        // 将来の参照のために持たせる
        private List<QuestionDto> questions;
        private List<AnswerDto> answers;
    }
}
