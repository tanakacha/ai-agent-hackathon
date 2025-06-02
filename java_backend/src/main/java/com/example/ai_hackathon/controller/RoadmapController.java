package com.example.ai_hackathon.controller;

import com.example.service.RoadmapGenerationService;
import com.example.dto.RoadmapRequest;
import com.example.dto.RoadmapResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/roadmap")
public class RoadmapController {

    private final RoadmapGenerationService roadmapGenerationService;

    @Autowired
    public RoadmapController(RoadmapGenerationService roadmapGenerationService) {
        this.roadmapGenerationService = roadmapGenerationService;
    }

    @PostMapping("/generate")
    public RoadmapResponse generateRoadmap(@RequestBody RoadmapRequest request) {
        return roadmapGenerationService.generateRoadmap(request);
    }
}
