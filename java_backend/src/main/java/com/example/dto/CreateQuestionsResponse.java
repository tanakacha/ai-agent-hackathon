package com.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

/**
 * 質問生成API (/questions) のレスポンスボディを表します。
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateQuestionsResponse {
    private List<QuestionDto> questions;
}
