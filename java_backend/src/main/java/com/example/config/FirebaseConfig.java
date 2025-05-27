package com.example.config;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;

import io.github.cdimascio.dotenv.Dotenv;

@Configuration
public class FirebaseConfig {

    private final FirebaseApp firebaseApp;

    public FirebaseConfig() throws IOException {
        Dotenv dotenv = Dotenv.configure().load();

        String credentialsJson = dotenv.get("FIREBASE_CREDENTIALS");
        InputStream serviceAccount = new ByteArrayInputStream(credentialsJson.getBytes(StandardCharsets.UTF_8));

        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

        this.firebaseApp = FirebaseApp.initializeApp(options);
    }

    @Bean
    public FirebaseApp firebaseApp() {
        return firebaseApp;
    }

    @Bean
    public Firestore firestore() {
        return FirestoreClient.getFirestore(firebaseApp);
    }
}
