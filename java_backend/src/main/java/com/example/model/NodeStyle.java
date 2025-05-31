package com.example.model;

import java.util.List;

import com.example.style.NodeStyleConstants;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NodeStyle {
    private String id;
    private double positionDx;
    private double positionDy;
    private double sizeWidth;
    private double sizeHeight;
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
    
    public static NodeStyle createNodeStyle() {
        NodeStyle ns = new NodeStyle();
        ns.sizeWidth = NodeStyleConstants.SIZE_WIDTH;
        ns.sizeHeight = NodeStyleConstants.SIZE_HEIGHT;
        ns.textColor = NodeStyleConstants.TEXT_COLOR;
        ns.fontFamily = NodeStyleConstants.FONT_FAMILY;
        ns.textSize = NodeStyleConstants.TEXT_SIZE;
        ns.textIsBold = NodeStyleConstants.TEXT_IS_BOLD;
        ns.kind = NodeStyleConstants.KIND;
        ns.handlers = NodeStyleConstants.HANDLERS;
        ns.handlerSize = NodeStyleConstants.HANDLER_SIZE;
        ns.backgroundColor = NodeStyleConstants.BACKGROUND_COLOR;
        ns.borderColor = NodeStyleConstants.BORDER_COLOR;
        ns.borderThickness = NodeStyleConstants.BORDER_THICKNESS;
        ns.elevation = NodeStyleConstants.ELEVATION;
        return ns;
    }
}
