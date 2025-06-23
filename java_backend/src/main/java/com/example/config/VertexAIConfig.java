package com.example.config;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.secretmanager.v1.AccessSecretVersionResponse;
import com.google.cloud.secretmanager.v1.SecretManagerServiceClient;
import com.google.cloud.secretmanager.v1.SecretVersionName;
import com.google.cloud.vertexai.VertexAI;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import com.google.protobuf.ByteString;

@Configuration
public class VertexAIConfig {

    @Value("${google.cloud.project-id}")
    private String projectId;

    @Value("${google.cloud.location}")
    private String location;

    @Value("${google.cloud.model}")
    private String modelName;

    @Value("${google.cloud.vertexai.secret-id}")
    private String secretId;  // 例: "verex-ai-key"

    @Value("${google.cloud.auth.type:secret-manager}")
    private String authType;

    @Bean(name = "vertexAIGoogleCredentials")
    public GoogleCredentials googleCredentials() throws IOException {
        if ("adc".equals(authType)) {
            // 開発環境では Application Default Credentials を使用
            return GoogleCredentials.getApplicationDefault()
                    .createScoped("https://www.googleapis.com/auth/cloud-platform");
        } else {
            // 本番環境では Secret Manager を使用
            try (SecretManagerServiceClient client = SecretManagerServiceClient.create()) {
                SecretVersionName secretVersionName =
                        SecretVersionName.of(projectId, secretId, "latest");

                AccessSecretVersionResponse response = client.accessSecretVersion(secretVersionName);
                ByteString secretData = response.getPayload().getData();

                try (InputStream keyStream = new ByteArrayInputStream(secretData.toByteArray())) {
                    return GoogleCredentials.fromStream(keyStream)
                            .createScoped("https://www.googleapis.com/auth/cloud-platform");
                }
            }
        }
    }

    @Bean
    public VertexAI vertexAI(@Qualifier("vertexAIGoogleCredentials") GoogleCredentials credentials) {
        return new VertexAI.Builder()
                .setProjectId(projectId)
                .setLocation(location)
                .setCredentials(credentials)
                .build();
    }

    @Bean
    public GenerativeModel generativeModel(VertexAI vertexAI) {
        return new GenerativeModel.Builder()
                .setModelName(modelName)
                .setVertexAi(vertexAI)
                .build();
    }
}
