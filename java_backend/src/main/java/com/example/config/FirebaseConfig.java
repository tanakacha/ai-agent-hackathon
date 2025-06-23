package com.example.config;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.secretmanager.v1.AccessSecretVersionResponse;
import com.google.cloud.secretmanager.v1.SecretManagerServiceClient;
import com.google.cloud.secretmanager.v1.SecretVersionName;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.protobuf.ByteString;

@Configuration
public class FirebaseConfig {

    @Value("${google.cloud.project-id}")
    private String projectId;

    @Value("${google.cloud.firebase.secret-id}")
    private String secretId; // 例: "firebase-key"

    @Value("${google.cloud.auth.type:secret-manager}")
    private String authType;

    @Bean(name = "firebaseGoogleCredentials")
    public GoogleCredentials googleCredentials() throws IOException {
        if ("adc".equals(authType)) {
            // 開発環境では Application Default Credentials を使用
            return GoogleCredentials.getApplicationDefault();
        } else {
            // 本番環境では Secret Manager を使用
            try (SecretManagerServiceClient client = SecretManagerServiceClient.create()) {
                SecretVersionName secretVersionName =
                        SecretVersionName.of(projectId, secretId, "latest");

                AccessSecretVersionResponse response = client.accessSecretVersion(secretVersionName);
                ByteString secretData = response.getPayload().getData();

                try (InputStream keyStream = new ByteArrayInputStream(secretData.toByteArray())) {
                    return GoogleCredentials.fromStream(keyStream);
                }
            }
        }
    }

    @Bean
    public FirebaseApp firebaseApp(@Qualifier("firebaseGoogleCredentials") GoogleCredentials credentials) throws IOException {
        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(credentials)
                .setProjectId(projectId)  // プロジェクトIDを明示的に設定
                .build();
        return FirebaseApp.initializeApp(options);
    }

    @Bean
    public Firestore firestore(FirebaseApp firebaseApp) {
        return FirestoreClient.getFirestore(firebaseApp);
    }
}
