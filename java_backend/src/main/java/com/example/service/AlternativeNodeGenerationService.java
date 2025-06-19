package com.example.service;

import com.example.dto.Node;
import com.example.dto.RoadMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;
import java.util.ArrayList;
import java.util.List;

@Service
public class AlternativeNodeGenerationService {
    private static final Logger logger = LoggerFactory.getLogger(AlternativeNodeGenerationService.class);

    private final SimpleLLMService llmService;
    private final NodeService nodeService;
    private final RoadMapService roadMapService;

    @Autowired
    public AlternativeNodeGenerationService(SimpleLLMService llmService, NodeService nodeService, RoadMapService roadMapService) {
        this.llmService = llmService;
        this.nodeService = nodeService;
        this.roadMapService = roadMapService;
    }

    
    public Node generateAndSaveSingleAlternative(String originalNodeId) {
      try{
        Node originalNode = nodeService.getNodeById(originalNodeId);
        if (originalNode == null) {
            logger.error("元ノードが見つかりません: ID={}", originalNodeId);
            throw new IllegalArgumentException("指定されたノードが存在しません: " + originalNodeId);
        }
        RoadMap roadMap = roadMapService.getRoadMap(originalNode.getMap_id());

        logger.info("開始: 単一代替ノード生成 (元ノード: {})", originalNode.getTitle());

        String llmResponse = requestSingleAlternativeTaskFromLLM(roadMap, originalNode);

        AlternativeTask task = parseSingleAlternativeTaskFromResponse(llmResponse);

        Node alternativeNode = createAlternativeNodeFromTask(originalNode, task);

        Node savedNode = nodeService.createNode(alternativeNode);
        logger.info("新規代替ノードを保存しました: ID={}, Title={}", savedNode.getId(), savedNode.getTitle());
        
        updateParentOfOriginalNode(originalNode, savedNode);

        logger.info("単一代替ノード生成完了。");
        return savedNode;
      } catch (Exception e) {
          logger.error("単一代替ノード生成中にエラーが発生しました: {}", e.getMessage(), e);
          throw new RuntimeException("代替ノード生成中にエラーが発生しました: " + e.getMessage(), e);
      }
    }

    private String requestSingleAlternativeTaskFromLLM(RoadMap roadMap, Node originalNode) {
        String prompt = createSingleAlternativeTaskPrompt(roadMap, originalNode);
        return llmService.askLLM(prompt);
    }

    private String createSingleAlternativeTaskPrompt(RoadMap roadMap, Node originalNode) {
        return String.format("""
            あなたは優秀なプロジェクトコンサルタントです。
            以下の全体目標と元のタスク情報を踏まえて、同じ目的を達成するための最も良い代替アプローチを1つだけ提案してください。

            ## 全体目標（Roadmap）
            - タイトル: %s
            - 目的: %s

            ## 元のタスク（Node）
            - タスク名: %s
            - タスク詳細: %s

            ## 指示
            - 提案は、元のタスクとは異なる視点や手段を用いるものにしてください。
            - 回答は以下の形式で、1行だけ出力してください。
            - 回答は「タイトル - 説明」の形式にしてください。

            回答形式:
            1. [代替案のタイトル] - [代替案の詳細な説明]
            """,
            roadMap.getTitle(),
            roadMap.getObjective(),
            originalNode.getTitle(),
            originalNode.getDescription()
        );
    }
    
    private Node createAlternativeNodeFromTask(Node originalNode, AlternativeTask task) {
        Node altNode = new Node();
        altNode.setMap_id(originalNode.getMap_id());
        altNode.setParent_id(originalNode.getParent_id());
        altNode.setTitle(task.getTitle());
        altNode.setDescription(task.getDescription());
        altNode.setNode_type("Task");
        altNode.setDuration(originalNode.getDuration());
        altNode.setDue_at(originalNode.getDue_at());
        altNode.setProgress_rate(0);
        altNode.setChildren_ids(new ArrayList<>());
        return altNode;
    }

    private AlternativeTask parseSingleAlternativeTaskFromResponse(String response) {
        String[] lines = response.split("\n");
        for (String line : lines) {
            line = line.trim();
            if (line.matches("^\\d+\\.\\s*.+")) {
                String content = line.substring(line.indexOf('.') + 1).trim();
                String[] parts = content.split(" - ", 2);
                if (parts.length == 2) {
                    return new AlternativeTask(parts[0].trim(), parts[1].trim());
                }
            }
        }
        return null;
    }

    private void updateParentOfOriginalNode(Node originalNode, Node newAlternativeNode) throws ExecutionException, InterruptedException {
        String parentId = originalNode.getParent_id();
        if (parentId == null || parentId.isEmpty()) {
            return;
        }

        Node parentNode = nodeService.getNodeById(parentId);
        if (parentNode == null) {
            logger.warn("親ノードが見つかりませんでした: {}", parentId);
            return;
        }

        List<String> currentChildrenIds = parentNode.getChildren_ids();
        if (currentChildrenIds == null) {
            currentChildrenIds = new ArrayList<>();
        }
        currentChildrenIds.add(newAlternativeNode.getId());
        parentNode.setChildren_ids(currentChildrenIds);

        nodeService.updateNode(parentNode);
        logger.info("親ノード({})の子IDリストを更新しました。", parentId);
    }

    private static class AlternativeTask {
        private final String title;
        private final String description;
        public AlternativeTask(String title, String description) { this.title = title; this.description = description; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
    }
}
