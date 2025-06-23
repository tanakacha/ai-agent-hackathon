package com.example.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

/**
 * 質問データ転送オブジェクト
 * 
 * このクラスは、質問のID、テキスト、タイプ、および選択肢のリストを表します。
 * JSONシリアライズ/デシリアライズのためにJacksonアノテーションを使用しています。
 */

 
/**
 * typeフィールドの値は以下のいずれかです:
 * - "text": テキスト入力
 * - "single_choice": 単一選択肢
 * - "multiple_choice": 複数選択肢
 *  single_choice, multiple_choiceの場合は、optionsフィールドにその選択肢のリストが含まれます。
 */

@Data
@NoArgsConstructor
public class QuestionDto {
    @JsonProperty("question_id")
    private String questionId;
    private String text;
    private String type;
    private List<String> options;
}
