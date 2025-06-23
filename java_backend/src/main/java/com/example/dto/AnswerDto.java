package com.example.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

/**
 * ユーザーからの一つの回答の構造を表します。
 */
@Data
@NoArgsConstructor
public class AnswerDto {
    @JsonProperty("question_id")
    private String questionId;
    // テキスト、単一選択、複数選択の全てをList<String>で統一的に扱います
    private List<String> value;
}
