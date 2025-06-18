package com.example.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dto.Node;

@Service
public class ChildNodeGenerationService {
    private static final Logger logger = LoggerFactory.getLogger(ChildNodeGenerationService.class);
    
    private final SimpleLLMService llmService;
    private final NodeService nodeService;
    
    @Autowired
    public ChildNodeGenerationService(SimpleLLMService llmService, NodeService nodeService) {
        this.llmService = llmService;
        this.nodeService = nodeService;
    }
    
    public List<Node> generateChildNodes(String mapId, Node parentNode) throws InterruptedException, ExecutionException {
        logger.info("開始: 子ノード生成 (親ノード: {})", parentNode.getTitle());
        
        String llmResponse = requestChildTasksFromLLM(parentNode.getDescription());

        List<Node> childNodes = createChildNodesFromLLMResponse(mapId, parentNode, llmResponse);

        List<Node> savedChildNodes = nodeService.createNodes(childNodes);

        updateParentNodeWithChildrenIds(parentNode, savedChildNodes);
        
        logger.info("子ノード生成完了 (生成件数: {})", savedChildNodes.size());
        return savedChildNodes;
    }
    
    private String requestChildTasksFromLLM(String description) {
        String prompt = createChildTaskPrompt(description);
        return llmService.askLLM(prompt);
    }
    
    private String createChildTaskPrompt(String description) {
        return String.format("""
            以下のタスクを3-4個の具体的で実行可能な細かいサブタスクに分解してください。
            
            メインタスク: %s
            
            以下の要件に従ってサブタスクを作成してください：
            1. 各サブタスクは具体的で実行可能な内容にする
            2. メインタスクを達成するために必要な手順を順序立てて考える
            3. 各サブタスクは1-3時間程度で完了できる規模にする
            4. 学習や作業の流れを考慮した論理的な順序にする
            
            回答は以下の形式で出力してください：
            1. [サブタスク1のタイトル] - [サブタスク1の説明]
            2. [サブタスク2のタイトル] - [サブタスク2の説明]
            3. [サブタスク3のタイトル] - [サブタスク3の説明]
            4. [サブタスク4のタイトル] - [サブタスク4の説明]（必要に応じて）
            
            各サブタスクのタイトルは10文字以内で簡潔に表現してください。
            
            例:
            1. HTML作成 - 基本的なHTML構造を持つindex.htmlファイルを作成する
            2. CSS準備 - CSSファイルを作成し、HTMLにリンクする
            """, description);
    }
    
    private List<Node> createChildNodesFromLLMResponse(String mapId, Node parentNode, String llmResponse) {
        List<Node> childNodes = new ArrayList<>();
        
        List<ChildTask> childTasks = parseChildTasksFromResponse(llmResponse);
        
        Date now = new Date();
        
        for (int i = 0; i < childTasks.size(); i++) {
            ChildTask task = childTasks.get(i);
            
            Node childNode = new Node();
            childNode.setMap_id(mapId);
            childNode.setTitle(task.getTitle());
            childNode.setDescription(task.getDescription());
            childNode.setNode_type("Task");
            childNode.setDuration(2);
            childNode.setProgress_rate(0);
            childNode.setParent_id(parentNode.getId());
            childNode.setChildren_ids(new ArrayList<>());
            
            if (parentNode.getDue_at() != null) {
                long parentDueTime = parentNode.getDue_at().getTime();
                long currentTime = now.getTime();
                long timeRange = parentDueTime - currentTime;
                long childDueTime = currentTime + (timeRange * (i + 1) / childTasks.size());
                childNode.setDue_at(new Date(childDueTime));
            }
            
            childNodes.add(childNode);
        }
        
        return childNodes;
    }
    
    private List<ChildTask> parseChildTasksFromResponse(String response) {
        List<ChildTask> tasks = new ArrayList<>();
        
        String[] lines = response.split("\n");
        
        for (String line : lines) {
            line = line.trim();
            if (line.matches("^\\d+\\..*")) {
                String content = line.substring(line.indexOf('.') + 1).trim();
                
                String title;
                String description;
                
                if (content.contains(" - ")) {
                    String[] parts = content.split(" - ", 2);
                    title = parts[0].trim();
                    description = parts[1].trim();
                } else {
                    title = content;
                    description = content;
                }
                
                tasks.add(new ChildTask(title, description));
            }
        }
        
        if (tasks.isEmpty()) {
            tasks.add(new ChildTask("詳細検討", "詳細な検討と実装を行う"));
            tasks.add(new ChildTask("実装作業", "具体的な実装作業を進める"));
            tasks.add(new ChildTask("テスト・確認", "動作テストと品質確認を行う"));
        }
        
        return tasks;
    }
    
    private void updateParentNodeWithChildrenIds(Node parentNode, List<Node> childNodes) 
            throws InterruptedException, ExecutionException {
        
        List<String> childrenIds = new ArrayList<>();
        for (Node child : childNodes) {
            childrenIds.add(child.getId());
        }
        
        // 既存の子ノードIDがある場合は追加
        if (parentNode.getChildren_ids() != null) {
            childrenIds.addAll(parentNode.getChildren_ids());
        }
        
        parentNode.setChildren_ids(childrenIds);
        nodeService.updateNode(parentNode);
        
        logger.info("親ノードの children_ids 更新完了: {}", parentNode.getId());
    }
    
    private static class ChildTask {
        private final String title;
        private final String description;
        
        public ChildTask(String title, String description) {
            this.title = title;
            this.description = description;
        }
        
        public String getTitle() {
            return title;
        }
        
        public String getDescription() {
            return description;
        }
    }
}
