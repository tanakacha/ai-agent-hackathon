package com.example.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

/**
 * ロードマップ本体生成API (/roadmaps) へのリクエストボディを表します。
 * 新しいフローに必要な全てのコンテキスト情報を含みます。
 */
@Data
@NoArgsConstructor
public class CreateRoadmapRequest {
    private String goal;
    private List<AnswerDto> answers;
    private int totalEstimatedHours;
}
