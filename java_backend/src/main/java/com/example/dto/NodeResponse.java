package com.example.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NodeResponse {
    private String id;
    private double positionDx;
    private double positionDy;
    private double sizeWidth;
    private double sizeHeight;
    private String text;
    private long textColor; // ARGB等の色コード（整数）
    private String fontFamily; // null可
    private double textSize;
    private boolean textIsBold;
    private int kind;
    private List<Integer> handlers;
    private double handlerSize;
    private long backgroundColor;
    private long borderColor;
    private double borderThickness;
    private double elevation;
    private Object data; // 任意のカスタムデータ
    private List<NextNode> next;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class NextNode {
        private String destElementId;
        private ArrowParams arrowParams;
        private List<Object> pivots; // 空配列など

        @Getter
        @Setter
        @NoArgsConstructor
        @AllArgsConstructor
        public static class ArrowParams {
            private double thickness;
            private double headRadius;
            private double tailLength;
            private long color;
            private String style; // null可
            private double tension;
            private double startArrowPositionX;
            private double startArrowPositionY;
            private double endArrowPositionX;
            private double endArrowPositionY;
        }
    }
}
