package com.example.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 要求された質問が見つからない場合にスローされる例外。
 * @ResponseStatusアノテーションにより、この例外がコントローラでキャッチされなかった場合、
 * Springは自動的にHTTP 404 Not Foundステータスを返します。
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class QuestionNotFoundException extends RuntimeException {

    public QuestionNotFoundException(String message) {
        super(message);
    }
}
