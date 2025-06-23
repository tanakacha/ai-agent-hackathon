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
public class UserMapsListResponse {
    private List<MapSummary> maps;
    private String message;
    
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MapSummary {
        private String mapId;
        private String title;
        private String objective;
        private String deadline;
    }
}
