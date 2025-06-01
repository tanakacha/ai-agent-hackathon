package com.example.ai_hackathon.controller;

import com.example.service.RoadmapGenerationService;
import com.example.model.RoadmapRequest;
import com.example.model.RoadmapResponse;
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
        return roadmapGenerationService.generateRoadmap(request.getGoal(), request.getDeadline());
    }

    @GetMapping("/generate")
    public RoadmapResponse generateRoadmapGet(
            @RequestParam(value = "goal") String goal,
            @RequestParam(value = "deadline") String deadline) {
        return roadmapGenerationService.generateRoadmap(goal, deadline);
    }
}
