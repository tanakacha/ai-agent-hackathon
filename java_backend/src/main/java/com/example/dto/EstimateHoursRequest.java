package com.example.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

/**
 * 必要時間算出API (/estimations) へのリクエストボディを表します。
 */
@Data
@NoArgsConstructor
public class EstimateHoursRequest {
    private String goal;
    private List<AnswerDto> answers;
    private List<QuestionDto> questions;
}
