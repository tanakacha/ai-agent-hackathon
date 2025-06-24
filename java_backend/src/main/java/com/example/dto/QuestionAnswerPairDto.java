package com.example.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 質問と回答のペアを保持するデータ転送オブジェクト(DTO)。
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuestionAnswerPairDto {
    /**
     * 質問のテキスト。
     */
    private String question;

    /**
     * ユーザーの回答。
     */
    private String answer;
}
