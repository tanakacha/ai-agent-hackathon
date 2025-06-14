package com.example.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RoadmapResponse {
    private List<Element> elements;
    private List<Connection> connections;
    private GridBackgroundParams gridBackgroundParams;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Element {
        private String id;
        private String text;
        private int kind; // 0: milestone, 1: start, 2: end
        private Object data;
        private List<String> parentIds;
        private List<String> childIds;
        private boolean draggable;
        private boolean resizable;
        private boolean connectable;
        private boolean deletable;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Connection {
        private String id;
        private String source;
        private String target;
        private String type;
        private ArrowParams arrowParams;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ArrowParams {
        private String arrowHeadType;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class GridBackgroundParams {
        private String color;
        private double size;
    }
}
