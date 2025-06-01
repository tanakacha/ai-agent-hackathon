package com.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RoadmapResponse {
    private List<Element> elements;
    private double dashboardSizeWidth;
    private double dashboardSizeHeight;
    private GridBackgroundParams gridBackgroundParams;
    private boolean blockDefaultZoomGestures;
    private double minimumZoomFactor;
    private int arrowStyle;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Element {
        private double positionDx;
        private double positionDy;
        private double sizeWidth;
        private double sizeHeight;
        private String text;
        private long textColor;
        private String fontFamily;
        private double textSize;
        private boolean textIsBold;
        private String id;
        private int kind;
        private List<Integer> handlers;
        private double handlerSize;
        private long backgroundColor;
        private long borderColor;
        private double borderThickness;
        private double elevation;
        private Object data;
        private List<Connection> next;
        private boolean draggable;
        private boolean resizable;
        private boolean connectable;
        private boolean deletable;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Connection {
        private String destElementId;
        private ArrowParams arrowParams;
        private List<Object> pivots;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ArrowParams {
        private double thickness;
        private double headRadius;
        private double tailLength;
        private long color;
        private Integer style;
        private double tension;
        private double startArrowPositionX;
        private double startArrowPositionY;
        private double endArrowPositionX;
        private double endArrowPositionY;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class GridBackgroundParams {
        private double offsetDx;
        private double offsetDy;
        private double scale;
        private double gridSquare;
        private double gridThickness;
        private int secondarySquareStep;
        private long backgroundColor;
        private long gridColor;
    }
}
