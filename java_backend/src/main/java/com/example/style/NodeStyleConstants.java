package com.example.style;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

@AllArgsConstructor
public class NodeStyleConstants {
    public static final double SIZE_WIDTH = 100.0;
    public static final double SIZE_HEIGHT = 50.0;
    public static final long TEXT_COLOR = 4278190080L;  // ARGB
    public static final String FONT_FAMILY = null;
    public static final double TEXT_SIZE = 24.0;
    public static final boolean TEXT_IS_BOLD = false;
    public static final int KIND = 0;
    public static final List<Integer> HANDLERS = List.of(1, 0, 3, 2);
    public static final double HANDLER_SIZE = 25.0;
    public static final long BACKGROUND_COLOR = 4294967295L;
    public static final long BORDER_COLOR = 4280391411L;
    public static final double BORDER_THICKNESS = 3.0;
    public static final double ELEVATION = 4.0;

    
    public static NodeStyleConstants getDefault() {
        return new NodeStyleConstants();
    }
}
