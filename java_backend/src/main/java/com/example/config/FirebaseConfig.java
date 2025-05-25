package com.example.config;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.auth.oauth2.ServiceAccountCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;

@Configuration
public class FirebaseConfig {

    private static final String FIREBASE_CREDENTIALS = "{\n" +
            "  \"type\": \"service_account\",\n" +
            "  \"project_id\": \"ai-hackathon-460510\",\n" +
            "  \"private_key_id\": \"d22b9ce2f667d3f92562aea8fa7ba74f16a86939\",\n" +
            "  \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCodpabfULpLatl\\nT9G9E0UL/5xNMTCjKf2Rykpq5+PVGeXDInwj8lbCCfoQalMjc7l9SUtsC/rPILSS\\nWBWjqaDiw+dZub1kZ5VkYTw2+A/6XrHNcORXJGkLo2CE2OW1R5tmKGm2bgavB13+\\nHbzohPQ5nQAG0k6qZntYfl8ELq159j4B438AuZgojQFn1pksIMKMLE24EbTOB84b\\nIVbcKD3vBFCmKxszU4zi35OCCsiu+ECBgRwe1r21JXUJsWXp59CY5XOiU8g48tjn\\nS2YubF/ye2xszk7mT6YpAAa/NnQ+LmSdUzFbUihy8OkzKaBGtUFPwIoTPaj4sKgo\\nlX0tUOBtAgMBAAECggEAGWKRTEniUMfQeXo/JSonr+irEVi1twiHTLY6Y4Sg6MY3\\nwKFMKpCEcUXWmC2lbISuMUpfop7lgtuvShQa4qgXdcRGctdRyjTvpooebDwSEEy/\\npzD5P4Zdi+LpEuuqJZhuOsUhNNu8hxhpmfa6NiF+ucXGMMD1GKlLseiNAdDU1Dk/\\nN3AetMG5INxn45wZmkajLyfQDq1X56ZUme/sEAYP9huiQM11GNHY96PlSuN/gxH4\\nL3snQ+HAz/z6u/GTcOnkSzv9GKSFBLl3t/Z9VNinNlZ5gK8h/4f9vZiAoMzxE5I5\\nNmMhCUYuST8Vgnp+PI5mN6yElTnQ84oG+p0b7x5gYQKBgQDtPC8bFyZayBfOL8RJ\\nuQF45UT/1yVQpVlx5JaB7+KSuuPzC4dl1zEyCCXlvf5ELrYdKoln4hqwcI3dqkbp\\nqVI3FNAthdlNPYmYMQFpC/pMJ1HDPOPFb9bCggtZy+0TEsHp4hHwHdoMPpUHFf1G\\nS48IzQ1JP4xFqplSdjU566Q5fQKBgQC1ydSialKALXDj8meJ70KOfsMi8Bc9Sbap\\ndLRVg5sY+BLtpTk1HOj6/g/ByKSEpE3tH6PChQ78kUOYio5q0cuAKQWsOv/clns3\\n/alxELcBHdNUT+AZLJe684MkIp6n1a0wLL+umQJ787lT/a1TEkTUEi0sloFB/DBW\\nNio5vKt1sQKBgGFPKHtSOZdPMASRL1CWJHZ0hKL0mwfDazb+boYJ4cQSCOJuvjEV\\n3cYJ9ZGRJzTMfELmacpEwnHRGT/tUn0RyPly/hlOJ944+bGFmHCAS0Dld/I/jaY0\\nw8CxGvrQXQRP016eLoFxnTkcioCHkoY9BAS2J1b+TAlfetiKSDbj4075AoGAeTui\\nnLX/Uw/662mrdyei4VjUViZ7uRnBwXzdDvJ3qs02AlpfrnYbQdfRNlDStsrEVVD2\\nazFFb1aJF9+/XqmO52d0KwolvDx27D40k/yrrwju+JlUQDWm8ryXRq/30sIDf883\\n/f5406UUgVj6EB5s3GlKyyOMDC9dJQF2Y47ZYeECgYBawxLQzoI2tWN95OSBQdIX\\nKwIomoDbmSEIPGVC141I1vERMXEEZZvd896nZd5xtNIlByw7zkMM/02PJaXsjaG2\\naUSClnMG+sRTRxzXm0P20T0XSUDdgUftINM2oz1Qcmzlcraz0MAOFGQCPili5g/i\\njkA5olg7ZmpvR5plwwv7EQ==\\n-----END PRIVATE KEY-----\\n\",\n" +
            "  \"client_email\": \"firebase-adminsdk-fbsvc@ai-hackathon-460510.iam.gserviceaccount.com\",\n" +
            "  \"client_id\": \"107768880272707970372\",\n" +
            "  \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",\n" +
            "  \"token_uri\": \"https://oauth2.googleapis.com/token\",\n" +
            "  \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",\n" +
            "  \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40ai-hackathon-460510.iam.gserviceaccount.com\",\n" +
            "  \"universe_domain\": \"googleapis.com\"\n" +
            "}";

    @Bean
    public Firestore firestore() throws IOException {
        InputStream serviceAccount = new ByteArrayInputStream(FIREBASE_CREDENTIALS.getBytes());
        GoogleCredentials credentials = ServiceAccountCredentials.fromStream(serviceAccount);
        
        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(credentials)
                .build();

        if (FirebaseApp.getApps().isEmpty()) {
            FirebaseApp.initializeApp(options);
        }

        return FirestoreClient.getFirestore();
    }
}
