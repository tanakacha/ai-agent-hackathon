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
    private String answer;
}
