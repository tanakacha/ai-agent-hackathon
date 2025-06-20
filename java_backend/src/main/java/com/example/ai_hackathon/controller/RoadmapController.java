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

import com.example.dto.AddChildNodesRequest;
import com.example.dto.AddChildNodesResponse;
import com.example.dto.AlternativeNodeRequest;
import com.example.dto.DetailedRoadmapRequest;
import com.example.dto.DetailedRoadmapResponse;
import com.example.dto.Node;
import com.example.dto.RoadMap;
import com.example.dto.RoadmapRequest;
import com.example.dto.RoadmapResponse;
import com.example.service.AlternativeNodeGenerationService;
import com.example.service.ChildNodeGenerationService;
import com.example.service.DetailedRoadmapGenerationService;
import com.example.service.NodeService;
import com.example.service.RoadMapService;
import com.example.service.RoadmapGenerationService;

@RestController
@RequestMapping("/api/roadmap")
public class RoadmapController {

    private final RoadmapGenerationService roadmapGenerationService;
    private final DetailedRoadmapGenerationService detailedRoadmapGenerationService;
    private final RoadMapService roadMapService;
    private final ChildNodeGenerationService childNodeGenerationService;
    private final NodeService nodeService;
    private final AlternativeNodeGenerationService alternativeNodeGenerationService;

    @Autowired
    public RoadmapController(RoadmapGenerationService roadmapGenerationService, 
                           DetailedRoadmapGenerationService detailedRoadmapGenerationService,
                           RoadMapService roadMapService,
                           ChildNodeGenerationService childNodeGenerationService,
                           NodeService nodeService,
                           AlternativeNodeGenerationService alternativeNodeGenerationService
                           ) {
        this.roadmapGenerationService = roadmapGenerationService;
        this.detailedRoadmapGenerationService = detailedRoadmapGenerationService;
        this.roadMapService = roadMapService;
        this.childNodeGenerationService = childNodeGenerationService;
        this.nodeService = nodeService;
        this.alternativeNodeGenerationService = alternativeNodeGenerationService;
    }

    @PostMapping("/generate")
    public RoadmapResponse generateRoadmap(@RequestBody RoadmapRequest request) {
        return roadmapGenerationService.generateRoadmap(request.getGoal(), request.getDeadline());
    }

    @PostMapping("/generate-detailed")
    public DetailedRoadmapResponse generateDetailedRoadmap(@RequestBody DetailedRoadmapRequest request) {
        return detailedRoadmapGenerationService.generateDetailedRoadmap(request);
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

    @PostMapping("/add-child-nodes")
    public AddChildNodesResponse addChildNodes(@RequestBody AddChildNodesRequest request) {
        try {
            Node parentNode = nodeService.getNodeById(request.getNodeId());
            if (parentNode == null) {
                AddChildNodesResponse errorResponse = new AddChildNodesResponse();
                errorResponse.setMessage("指定されたノードが見つかりませんでした: " + request.getNodeId());
                return errorResponse;
            }

            if (!request.getMapId().equals(parentNode.getMap_id())) {
                AddChildNodesResponse errorResponse = new AddChildNodesResponse();
                errorResponse.setMessage("ノードのマップIDが一致しません");
                return errorResponse;
            }

            List<Node> childNodes = childNodeGenerationService.generateChildNodes(request.getMapId(), parentNode);

            AddChildNodesResponse response = new AddChildNodesResponse();
            response.setParentNodeId(parentNode.getId());
            response.setChildNodes(childNodes);
            response.setMessage("子ノードを正常に生成しました");

            return response;

        } catch (Exception e) {
            AddChildNodesResponse errorResponse = new AddChildNodesResponse();
            errorResponse.setMessage("子ノード生成中にエラーが発生しました: " + e.getMessage());
            return errorResponse;
        }
    }
    @PostMapping("/nodes/generate-alternative")
    public Node generateSingleAlternativeNode(@RequestBody AlternativeNodeRequest request) { 
        Node savedNode = alternativeNodeGenerationService.generateAndUpdateNode(request.getNodeId());
        return savedNode;
    }
}
