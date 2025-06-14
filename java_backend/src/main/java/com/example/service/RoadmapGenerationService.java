package com.example.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dto.Node;
import com.example.dto.RoadmapResponse;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;

@Service
public class RoadmapGenerationService {

    private final GenerativeModel generativeModel;
    private final NodeService nodeService;
    private final RoadMapService roadMapService;

    @Autowired
    public RoadmapGenerationService(GenerativeModel generativeModel, 
                                   NodeService nodeService, 
                                   RoadMapService roadMapService) {
        this.generativeModel = generativeModel;
        this.nodeService = nodeService;
        this.roadMapService = roadMapService;
    }

    public RoadmapResponse generateRoadmap(String goal, String deadline) {
        try {
            String mapId = generateMapId();
            String llmResponse = generateRoadmapFromLLM(goal, deadline);

            List<Node> nodes = createNodesFromLLMResponse(llmResponse, mapId);

            roadMapService.createRoadMap(mapId, goal, deadline);

            List<Node> savedNodes = nodeService.createNodes(nodes);
            
            return new RoadmapResponse(mapId, savedNodes);
        } catch (Exception e) {
            throw new RuntimeException("ロードマップ生成中にエラーが発生しました: " + e.getMessage(), e);
        }
    }

    private String generateRoadmapFromLLM(String goal, String deadline) {
        String prompt = createRoadmapPrompt(goal, deadline);
        
        try {
            GenerateContentResponse response = generativeModel.generateContent(
                ContentMaker.fromMultiModalData(prompt)
            );
            
            if (response.getCandidatesList().isEmpty()) {
                return "ロードマップが生成されませんでした。";
            }
            
            return response.getCandidates(0)
                    .getContent()
                    .getParts(0)
                    .getText();
                    
        } catch (Exception e) {
            e.printStackTrace();
            return "LLMの呼び出し中にエラーが発生しました: " + e.getMessage();
        }
    }

    private String createRoadmapPrompt(String goal, String deadline) {
        return String.format("""
            あなたはプロジェクトマネージャーです。以下の情報を基にロードマップを作成してください。
            
            目標: %s
            期限: %s
            
            以下の要件に従って実用的なロードマップを作成してください：
            1. 目標達成のために必要な主要なマイルストーンを3-5個特定する
            2. 各マイルストーンは実現可能で具体的な内容にする
            3. マイルストーン間の論理的な順序を考慮する
            
            応答は以下のフォーマットで列挙してください：
            
            マイルストーン:
            1. [最初のマイルストーン]
            2. [2番目のマイルストーン]
            3. [3番目のマイルストーン]
            4. [4番目のマイルストーン]
            5. [5番目のマイルストーン]
            
            各マイルストーンは15文字以内で簡潔に表現してください。
            """, goal, deadline);
    }

    private String generateMapId() {
        return "map-" + UUID.randomUUID().toString().substring(0, 8);
    }

    private List<Node> createNodesFromLLMResponse(String llmResponse, String mapId) {
        List<String> milestones = extractMilestones(llmResponse);
        
        if (milestones.isEmpty()) {
            milestones = createDefaultMilestones();
        }
        
        List<Node> nodes = new ArrayList<>();
        Date now = new Date();
        
        // ルートノード
        Node rootNode = createNode(
            "node-1",
            mapId,
            "プロジェクト開始",
            "プロジェクトの開始点",
            "Root",
            null,
            new ArrayList<>(),
            now
        );
        nodes.add(rootNode);

        String previousId = "node-1";
        for (int i = 0; i < milestones.size(); i++) {
            String nodeId = "node-" + (i + 2);
            String title = milestones.get(i);
            
            Node milestoneNode = createNode(
                nodeId,
                mapId,
                title,
                title + "を達成する",
                "Task",
                previousId,
                new ArrayList<>(),
                now
            );
            nodes.add(milestoneNode);

            Node previousNode = findNodeById(nodes, previousId);
            if (previousNode != null) {
                previousNode.getChildren_ids().add(nodeId);
            }
            
            previousId = nodeId;
        }
        
        return nodes;
    }

    private List<String> extractMilestones(String llmResponse) {
        List<String> milestones = new ArrayList<>();
        String[] lines = llmResponse.split("\n");
        boolean inMilestoneSection = false;
        
        for (String line : lines) {
            line = line.trim();
            
            if (line.contains("マイルストーン:") || line.contains("Milestone")) {
                inMilestoneSection = true;
                continue;
            }
            
            if (inMilestoneSection && !line.isEmpty()) {
                if (line.matches("^\\d+\\.\\s*(.+)$")) {
                    String milestone = line.replaceFirst("^\\d+\\.\\s*", "").trim();
                    // 15文字制限を適用
                    if (milestone.length() > 15) {
                        milestone = milestone.substring(0, 12) + "...";
                    }
                    milestones.add(milestone);
                }
                
                // 最大5個まで
                if (milestones.size() >= 5) {
                    break;
                }
            }
        }
        
        return milestones;
    }

    private List<String> createDefaultMilestones() {
        return List.of("要件定義", "設計フェーズ", "開発開始", "テスト実行", "最終調整");
    }

    private Node createNode(String id, String mapId, String title, String description, 
                           String nodeType, String parentId, List<String> childrenIds, Date now) {
        Node node = new Node();
        node.setId(id);
        node.setMap_id(mapId);
        node.setTitle(title);
        node.setDescription(description);
        node.setNode_type(nodeType);
        node.setParent_id(parentId);
        node.setChildren_ids(childrenIds);
        node.setCreated_at(now);
        node.setUpdated_at(now);
        node.setDue_at(null);
        node.setFinished_at(null);
        node.setDuration(0);
        node.setProgress_rate(0);
        
        return node;
    }

    private Node findNodeById(List<Node> nodes, String id) {
        return nodes.stream()
                .filter(node -> node.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
}
