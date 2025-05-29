package com.example.ai_hackathon.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.reactive.function.client.WebClient;

@RestController
@RequestMapping("/api/pokemon")
public class PokemonController {

    private final WebClient webClient;

    public PokemonController(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.baseUrl("https://pokeapi.co/api/v2").build();
    }

    // 1匹詳細取得
    @GetMapping("/{name}")
    public ResponseEntity<String> getPokemon(@PathVariable String name) {
        try {
            String response = webClient.get()
                    .uri("/pokemon/{name}", name)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.status(404).body("{\"error\":\"Pokemon not found\"}");
        }
    }

    // ポケモン一覧取得
    @GetMapping
    public ResponseEntity<String> getPokemonList(
            @RequestParam(defaultValue = "20") int limit,
            @RequestParam(defaultValue = "0") int offset) {

        String response = webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/pokemon")
                        .queryParam("limit", limit)
                        .queryParam("offset", offset)
                        .build())
                .retrieve()
                .bodyToMono(String.class)
                .block();

        return ResponseEntity.ok(response);
    }
}
