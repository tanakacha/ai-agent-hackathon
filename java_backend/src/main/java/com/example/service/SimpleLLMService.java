package com.example.service;
    
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

@Service
public class SimpleLLMService {

    private final ChatClient chatClient;

    public SimpleLLMService(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder.build();
    }

    public String askLLM(String question) {
        try {
            return chatClient.prompt()
                    .user(question)
                    .call()
                    .content();
        } catch (Exception e) {
            e.printStackTrace();
            return "LLMの呼び出し中にエラーが発生しました: " + e.getMessage();
        }
    }
}
