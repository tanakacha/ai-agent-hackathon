package com.example.ai_hackathon;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = {
    "com.example.ai_hackathon",
    "com.example.service",
    "com.example.config",
    "com.example.repository"
})
public class AiHackathonApplication {

	public static void main(String[] args) {
		SpringApplication.run(AiHackathonApplication.class, args);
	}

}
