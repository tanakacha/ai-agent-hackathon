package com.example.ai_hackathon.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.dto.Node;
import com.example.dto.RoadMap;
import com.example.dto.RoadmapRequest;
import com.example.dto.RoadmapResponse;
import com.example.service.RoadMapService;
import com.example.service.RoadmapGenerationService;

@RestController
@RequestMapping("/api/roadmap")
public class RoadmapController {

    private final RoadmapGenerationService roadmapGenerationService;
    private final RoadMapService roadMapService;

    @Autowired
    public RoadmapController(RoadmapGenerationService roadmapGenerationService, RoadMapService roadMapService) {
        this.roadmapGenerationService = roadmapGenerationService;
        this.roadMapService = roadMapService;
    }

    @PostMapping("/generate")
    public RoadmapResponse generateRoadmap(@RequestBody RoadmapRequest request) {
        return roadmapGenerationService.generateRoadmap(request.getGoal(), request.getDeadline());
    }

    @GetMapping("/roadmap/{map_id}")
    public RoadMap getRoadmap(@PathVariable String map_id) {
        return roadMapService.getRoadMap(map_id);
    }

    @GetMapping("/roadmap/{map_id}/nodes")
    public List<Node> getNodes(@PathVariable String map_id) {
        return roadMapService.getNodes(map_id);
    }

    @GetMapping("/generate")
        public RoadmapResponse generateRoadmapGet(
                @RequestParam(value = "goal") String goal,
                @RequestParam(value = "deadline") String deadline) {
            return roadmapGenerationService.generateRoadmap(goal, deadline);
        }
}
