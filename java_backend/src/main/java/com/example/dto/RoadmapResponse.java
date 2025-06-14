package com.example.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RoadmapResponse {
    private String mapId;
    private List<Node> nodes;
    private String message;
    
    public RoadmapResponse(String mapId, List<Node> nodes) {
        this.mapId = mapId;
        this.nodes = nodes;
        this.message = "ロードマップを正常に生成しました";
    }
}
