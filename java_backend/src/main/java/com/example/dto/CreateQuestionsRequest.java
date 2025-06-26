package com.example.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 質問生成API (/questions) へのリクエストボディを表します。
 */
@Data
@NoArgsConstructor
public class CreateQuestionsRequest {
    private String goal;
}
