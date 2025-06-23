// package com.example.service;

// import com.example.dto.*;
// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;
// import org.springframework.stereotype.Service;

// import java.time.Instant;
// import java.util.ArrayList;
// import java.util.Date;
// import java.util.List;
// import java.util.UUID;

// /**
//  * ロードマップ生成の全プロセスを指揮する司令塔（オーケストレーター）。
//  */
// @Service
// public class RoadmapOrchestrationService {

//     private static final Logger logger = LoggerFactory.getLogger(RoadmapOrchestrationService.class);
//     private final LlmInteractionService llmService;
//     private final RoadmapDocumentService documentService;

//     public RoadmapOrchestrationService(LlmInteractionService llmService, RoadmapDocumentService documentService) {
//         this.llmService = llmService;
//         this.documentService = documentService;
//     }

//     public RoadmapResponse createFullRoadmap(CreateRoadmapRequest request) {
//         try {
//             logger.info("完全なロードマップの生成プロセスを開始します。Goal: {}", request.getGoal());
            
//             // 1. LLM対話サービスに依頼し、構造化されたロードマップ情報を取得
//             LlmInteractionService.LlmResponseDto llmResponse = llmService.generateRoadmapAsJson(request);

//             // 2. 永続化するRoadmapDocumentを準備
//             String mapId = "map-" + UUID.randomUUID().toString().substring(0, 8);
//             Instant now = Instant.now();
            
//             RoadmapDocument doc = new RoadmapDocument();
//             doc.setId(mapId);
//             // doc.setUserId(...); // TODO: 認証機能実装後、ユーザーIDを設定
//             doc.setGoal(request.getGoal());
//             doc.setTotalEstimatedHours(request.getTotalEstimatedHours());
            
//             RoadmapDocument.CreationContext context = new RoadmapDocument.CreationContext();
//             context.setQuestions(request.getQuestions());
//             context.setAnswers(request.getAnswers());
//             doc.setCreationContext(context);
            
//             doc.setCreatedAt(now);
//             doc.setUpdatedAt(now);
            
//             // 3. LLMの応答から、Nodeオブジェクトのリストを生成する
//             List<Node> nodes = mapLlmResponseToNodes(llmResponse, mapId, Date.from(now));
//             doc.setNodes(nodes);

//             // 4. DB専門サービスに依頼し、完成したドキュメントを一度に保存
//             documentService.save(doc);
//             logger.info("RoadmapDocumentの保存が完了しました。ID: {}", mapId);

//             // 5. コントローラーが期待する形式でレスポンスを返す
//             return new RoadmapResponse(doc.getId(), doc.getNodes(), "ロードマップが正常に生成されました。");

//         } catch (Exception e) {
//             logger.error("ロードマップ生成のオーケストレーション中にエラーが発生しました。", e);
//             throw new RuntimeException("ロードマップ生成中にエラーが発生しました: " + e.getMessage(), e);
//         }
//     }

//     private List<Node> mapLlmResponseToNodes(LlmInteractionService.LlmResponseDto llmResponse, String mapId, Date creationDate) {
//         List<Node> nodes = new ArrayList<>();
//         int nodeCounter = 1;

//         Node rootNode = createNode("node-" + nodeCounter++, mapId, llmResponse.getRoadmapTitle(), "ロードマップの開始点", "Root", null, creationDate, 0);
//         nodes.add(rootNode);

//         String parentIdForPhase = rootNode.getId();
//         for (LlmInteractionService.LlmResponseDto.Phase phase : llmResponse.getPhases()) {
//             String phaseNodeId = "node-" + nodeCounter++;
//             int phaseTotalDuration = phase.getTasks().stream().mapToInt(LlmInteractionService.LlmResponseDto.Task::getDurationHours).sum();
//             Node phaseNode = createNode(phaseNodeId, mapId, phase.getPhaseTitle(), "フェーズ: " + phase.getPhaseTitle(), "Phase", parentIdForPhase, creationDate, phaseTotalDuration);
//             nodes.add(phaseNode);
//             findNodeById(nodes, parentIdForPhase).getChildren_ids().add(phaseNodeId);

//             for (LlmInteractionService.LlmResponseDto.Task task : phase.getTasks()) {
//                 String taskNodeId = "node-" + nodeCounter++;
//                 Node taskNode = createNode(taskNodeId, mapId, task.getTitle(), task.getDescription(), "Task", phaseNodeId, creationDate, task.getDurationHours());
//                 nodes.add(taskNode);
//                 phaseNode.getChildren_ids().add(taskNodeId);
//             }
//         }
//         return nodes;
//     }

//     private Node createNode(String id, String mapId, String title, String description, String nodeType, String parentId, Date now, int durationHours) {
//         Node node = new Node();
//         node.setId(id);
//         node.setMap_id(mapId);
//         node.setTitle(title);
//         node.setDescription(description);
//         node.setNode_type(nodeType);
//         node.setParent_id(parentId);
//         node.setChildren_ids(new ArrayList<>());
//         node.setCreated_at(now);
//         node.setUpdated_at(now);
//         node.setDuration(durationHours);
//         node.setProgress_rate(0);
//         return node;
//     }
    
//     private Node findNodeById(List<Node> nodes, String id) {
//         return nodes.stream().filter(n -> n.getId().equals(id)).findFirst().orElse(null);
//     }
// }
