package com.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CompleteNodeResponse {
    private Node node;
    private List<Node> completedNodes;
    private String message;
}
