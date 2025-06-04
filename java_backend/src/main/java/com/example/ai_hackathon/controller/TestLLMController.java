package com.example.ai_hackathon.controller;

import com.example.service.SimpleLLMService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestLLMController {

    private final SimpleLLMService simpleLLMService;

    @Autowired
    public TestLLMController(SimpleLLMService simpleLLMService) {
        this.simpleLLMService = simpleLLMService;
    }

    @GetMapping("/api/ask")
    public String askLLM(@RequestParam(value = "q", defaultValue = "日本の首都はどこですか？") String question) {
        return "LLMの回答: \n" + simpleLLMService.askLLM(question);
    }

    @GetMapping("/api/test-llm")
    public String testLLM() {
        String fixedQuestion = "こんにちは！今日の気分はどうですか？";
        return "固定の質問へのLLMの回答 ('" + fixedQuestion + "'): \n" + simpleLLMService.askLLM(fixedQuestion);
    }
}
