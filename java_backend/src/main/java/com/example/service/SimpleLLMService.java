package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;

@Service
public class SimpleLLMService {

    private final GenerativeModel generativeModel;

    @Autowired
    public SimpleLLMService(GenerativeModel generativeModel) {
        this.generativeModel = generativeModel;
    }

    public String askLLM(String question) {
        try {
            GenerateContentResponse response = generativeModel.generateContent(
                ContentMaker.fromMultiModalData(question)
            );
            
            if (response.getCandidatesList().isEmpty()) {
                return "レスポンスが生成されませんでした。";
            }
            
            return response.getCandidates(0)
                    .getContent()
                    .getParts(0)
                    .getText();
                    
        } catch (Exception e) {
            e.printStackTrace();
            return "LLMの呼び出し中にエラーが発生しました: " + e.getMessage();
        }
    }
}
