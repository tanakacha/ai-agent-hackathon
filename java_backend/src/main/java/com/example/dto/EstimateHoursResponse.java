package com.example.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 必要時間算出API (/estimations) のレスポンスボディを表します。
 */
@Data
@NoArgsConstructor
public class EstimateHoursResponse {
    private int minHours;
    private int maxHours;
    private String comment;
}
