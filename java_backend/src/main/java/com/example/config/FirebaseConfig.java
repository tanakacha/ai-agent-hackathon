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

    @Bean(name = "firebaseGoogleCredentials")
    public GoogleCredentials googleCredentials() throws IOException {
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

    @Bean
    public FirebaseApp firebaseApp(@Qualifier("firebaseGoogleCredentials") GoogleCredentials credentials) throws IOException {
        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(credentials)
                .build();
        return FirebaseApp.initializeApp(options);
    }

    @Bean
    public Firestore firestore(FirebaseApp firebaseApp) {
        return FirestoreClient.getFirestore(firebaseApp);
    }
}
