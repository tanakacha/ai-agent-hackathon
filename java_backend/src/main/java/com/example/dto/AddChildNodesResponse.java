package com.example.dto;

import java.util.List;
import lombok.Data;

@Data
public class AddChildNodesResponse {
    private String parentNodeId;
    private List<Node> childNodes;
    private String message;
}
