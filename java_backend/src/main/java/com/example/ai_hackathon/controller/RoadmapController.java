package com.example.ai_hackathon.controller;

import java.util.List;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.example.dto.RoadmapDocument;
import com.example.service.RoadmapService_v2;

import com.example.dto.CreateRoadmapRequest;
// import com.example.service.RoadmapOrchestrationService;
import com.example.dto.EstimateHoursRequest;
import com.example.dto.EstimateHoursResponse;
import com.example.service.EstimationService;
import com.example.dto.CreateQuestionsRequest;
import com.example.dto.CreateQuestionsResponse;
import com.example.service.QuestionGenerationService;
import com.example.dto.AddChildNodesRequest;
import com.example.dto.AddChildNodesResponse;
import com.example.dto.AlternativeNodeRequest;
import com.example.dto.CreateDetailedRoadmapRequest;
import com.example.dto.DetailedRoadmapRequest;
import com.example.dto.DetailedRoadmapResponse;
import com.example.dto.Node;
import com.example.dto.RoadMap;
import com.example.dto.RoadmapCreationResponseDto;
import com.example.dto.RoadmapDocument;
import com.example.dto.RoadmapRequest;
import com.example.dto.RoadmapResponse;
import com.example.service.AlternativeNodeGenerationService;
import com.example.service.ChildNodeGenerationService;
import com.example.service.DetailedRoadmapGenerationService;
import com.example.service.NodeService;
import com.example.service.RoadMapService;
import com.example.service.RoadmapGenerationService;
import com.example.service.RoadmapService_v2;

import org.springframework.http.HttpStatus;

@RestController
@RequestMapping("/api/roadmap")
public class RoadmapController {

    private final RoadmapGenerationService roadmapGenerationService;
    private final DetailedRoadmapGenerationService detailedRoadmapGenerationService;
    private final RoadMapService roadMapService;
    private final ChildNodeGenerationService childNodeGenerationService;
    private final NodeService nodeService;
    private final AlternativeNodeGenerationService alternativeNodeGenerationService;
    private final QuestionGenerationService questionGenerationService;
    private final EstimationService estimationService;
    private final RoadmapService_v2 roadmapService;
    // private final RoadmapOrchestrationService roadmapOrchestrationService;

    @Autowired
    public RoadmapController(RoadmapGenerationService roadmapGenerationService, 
                           DetailedRoadmapGenerationService detailedRoadmapGenerationService,
                           RoadMapService roadMapService,
                           ChildNodeGenerationService childNodeGenerationService,
                           NodeService nodeService,
                           AlternativeNodeGenerationService alternativeNodeGenerationService,
                           QuestionGenerationService questionGenerationService,
                           EstimationService estimationService,
                           RoadmapService_v2 roadmapService
                           ) {
        this.roadmapGenerationService = roadmapGenerationService;
        this.detailedRoadmapGenerationService = detailedRoadmapGenerationService;
        this.roadMapService = roadMapService;
        this.childNodeGenerationService = childNodeGenerationService;
        this.nodeService = nodeService;
        this.alternativeNodeGenerationService = alternativeNodeGenerationService;
        this.questionGenerationService = questionGenerationService;
        this.estimationService = estimationService;
        this.roadmapService = roadmapService;
    }

    // @PostMapping("/v2/roadmaps")
    // public ResponseEntity<RoadmapResponse> createRoadmap(@RequestBody CreateRoadmapRequest request) {
    //     try {
    //         RoadmapResponse response = roadmapOrchestrationService.createFullRoadmap(request);
    //         return ResponseEntity.ok(response);
    //     } catch (Exception e) {
    //         return ResponseEntity.internalServerError().build();
    //     }
    // }

    @PostMapping
    public ResponseEntity<RoadmapCreationResponseDto> createRoadmap(
            @RequestBody CreateRoadmapRequest request,
            @RequestHeader(value = "X-User-Id", defaultValue = "anonymous") String userId) {
        
        try {
            RoadmapCreationResponseDto response = roadmapService.createRoadmap(request, userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // デフォルトの質問リストを出力する
    @PostMapping("/v2/questions")
    public ResponseEntity<CreateQuestionsResponse> getQuestionsForRoadmap(@RequestBody CreateQuestionsRequest request) {
        try {
            CreateQuestionsResponse response = questionGenerationService.generateQuestions(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // デフォルトの推定時間を出力する
    @PostMapping("/v2/estimations")
    public ResponseEntity<EstimateHoursResponse> getEstimatedHours(@RequestBody EstimateHoursRequest request) {
        try {
            EstimateHoursResponse response = estimationService.estimateHours(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
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
    @PostMapping("/create-with-user")
    public DetailedRoadmapResponse createDetailedRoadmapWithUser(@RequestBody CreateDetailedRoadmapRequest request) {
        try {
            // Convert CreateDetailedRoadmapRequest to DetailedRoadmapRequest
            DetailedRoadmapRequest detailedRequest = new DetailedRoadmapRequest();
            detailedRequest.setGoal(request.getGoal());
            detailedRequest.setDeadline(request.getDeadline());
            
            DetailedRoadmapRequest.UserProfile userProfile = new DetailedRoadmapRequest.UserProfile();
            userProfile.setUserType(DetailedRoadmapRequest.UserProfile.UserType.valueOf(request.getUserType().toString()));
            userProfile.setAvailableHoursPerDay(request.getAvailableHoursPerDay());
            userProfile.setAvailableDaysPerWeek(request.getAvailableDaysPerWeek());
            userProfile.setExperienceLevel(DetailedRoadmapRequest.UserProfile.ExperienceLevel.valueOf(request.getExperienceLevel().toString()));
            
            detailedRequest.setUserProfile(userProfile);
            
            // Generate roadmap
            DetailedRoadmapResponse response = detailedRoadmapGenerationService.generateDetailedRoadmap(detailedRequest);
            
            // Update the roadmap with user_id
            roadMapService.updateRoadmapUserId(response.getMapId(), request.getUserId());
            
            return response;
        } catch (Exception e) {
            DetailedRoadmapResponse errorResponse = new DetailedRoadmapResponse();
            errorResponse.setMessage("ユーザー指定ロードマップ作成中にエラーが発生しました: " + e.getMessage());
            return errorResponse;
        }
    }
}
