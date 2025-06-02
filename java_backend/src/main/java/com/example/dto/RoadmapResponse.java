package com.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RoadmapResponse {
    private List<Element> elements;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Element {
        private String id;
        private String text;
        private LocalDate deadline;
        private int kind; // 0: milestone, 1: start, 2: end
        private Object data;
        private List<String> parentIds;
        private List<String> childIds;
        private boolean draggable;
        private boolean resizable;
        private boolean connectable;
        private boolean deletable;
    }
}
