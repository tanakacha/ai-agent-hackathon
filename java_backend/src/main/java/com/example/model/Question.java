package com.example.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Question {

    @NonNull
    private String id;

    @NonNull
    private String question;

    @NonNull
    private QuestionType type;

    private String[] options;
}

