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

    
    public Node generateAndUpdateNode(String originalNodeId) {
      try {
        Node originalNode = nodeService.getNodeById(originalNodeId);
        if (originalNode == null) {
            logger.error("元ノードが見つかりません: ID={}", originalNodeId);
            throw new IllegalArgumentException("指定されたノードが存在しません: " + originalNodeId);
        }
        RoadMap roadMap = roadMapService.getRoadMap(originalNode.getMap_id());

        logger.info("開始: 代替案によるノード更新 (元ノード: {})", originalNode.getTitle());

        String llmResponse = requestSingleAlternativeTaskFromLLM(roadMap, originalNode);

        AlternativeTask task = parseSingleAlternativeTaskFromResponse(llmResponse);
        updateNodeWithAlternativeTask(originalNode, task);

        Node updatedNode = nodeService.updateNode(originalNode);
        logger.info("ノードを更新しました: ID={}, Title={}", updatedNode.getId(), updatedNode.getTitle());
        
        
        return updatedNode;

      } catch (Exception e) {
          logger.error("代替案によるノード更新中にエラーが発生しました: {}", e.getMessage(), e);
          throw new RuntimeException("代替案によるノード更新中にエラーが発生しました: " + e.getMessage(), e);
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
    
    private void updateNodeWithAlternativeTask(Node nodeToUpdate, AlternativeTask task) {
        nodeToUpdate.setTitle(task.getTitle());
        nodeToUpdate.setDescription(task.getDescription());
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
        throw new IllegalArgumentException("Response does not match the expected format for an AlternativeTask.");
    }

    private static class AlternativeTask {
        private final String title;
        private final String description;
        public AlternativeTask(String title, String description) { this.title = title; this.description = description; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
    }
}
