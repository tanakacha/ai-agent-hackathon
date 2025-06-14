package com.example.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dto.RoadmapResponse;
import com.example.dto.RoadmapResponse.ArrowParams;
import com.example.dto.RoadmapResponse.Connection;
import com.example.dto.RoadmapResponse.Element;
import com.example.dto.RoadmapResponse.GridBackgroundParams;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;

@Service
public class RoadmapGenerationService {

    private final GenerativeModel generativeModel;

    @Autowired
    public RoadmapGenerationService(GenerativeModel generativeModel) {
        this.generativeModel = generativeModel;
    }

    public RoadmapResponse generateRoadmap(String goal, String deadline) {
        String llmResponse = generateRoadmapFromLLM(goal, deadline);
        
        // LLMレスポンスからロードマップデータを生成
        return createRoadmapFromLLMResponse(llmResponse);
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

    private RoadmapResponse createRoadmapFromLLMResponse(String llmResponse) {
        List<String> milestones = extractMilestones(llmResponse);
        
        if (milestones.isEmpty()) {
            milestones = createDefaultMilestones();
        }
        
        List<Element> elements = new ArrayList<>();
        List<Connection> connections = new ArrayList<>();
        
        // 開始ノード
        Element startElement = createElementWithDefaults(
            "start-node",
            "開始",
            1, // start node
            new ArrayList<>(), // no parents
            new ArrayList<>()  // children will be added
        );
        elements.add(startElement);
        
        // マイルストーンノードを生成
        String previousId = "start-node";
        for (int i = 0; i < milestones.size(); i++) {
            String milestoneId = "milestone-" + (i + 1);
            String milestoneText = milestones.get(i);
            
            List<String> parentIds = new ArrayList<>();
            parentIds.add(previousId);
            
            Element milestoneElement = createElementWithDefaults(
                milestoneId,
                milestoneText,
                0, // milestone node
                parentIds,
                new ArrayList<>() // children will be added
            );
            elements.add(milestoneElement);
            
            // 前のノードの子として追加
            Element previousElement = findElementById(elements, previousId);
            if (previousElement != null) {
                previousElement.getChildIds().add(milestoneId);
            }

            // コネクションを追加
            connections.add(createConnection(previousId, milestoneId));
            
            previousId = milestoneId;
        }

        // 完了ノード
        List<String> endParentIds = new ArrayList<>();
        endParentIds.add(previousId);
        
        Element endElement = createElementWithDefaults(
            "end-node",
            "完了",
            2, // end node
            endParentIds,
            new ArrayList<>() // no children
        );
        elements.add(endElement);
        
        // 最後のマイルストーンの子として完了ノードを追加
        Element lastMilestone = findElementById(elements, previousId);
        if (lastMilestone != null) {
            lastMilestone.getChildIds().add("end-node");
        }

        // 最後のコネクションを追加
        connections.add(createConnection(previousId, "end-node"));
        
        // グリッド背景パラメータ
        GridBackgroundParams gridParams = new GridBackgroundParams("#f0f0f0", 20.0);
        
        return new RoadmapResponse(elements, connections, gridParams);
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
        return Arrays.asList("要件定義", "設計フェーズ", "開発開始", "テスト実行", "最終調整");
    }

    private Element createElementWithDefaults(String id, String text, int kind, 
                                           List<String> parentIds, List<String> childIds) {
        Element element = new Element();
        element.setId(id);
        element.setText(text);
        element.setKind(kind);
        element.setData(null);
        element.setParentIds(parentIds);
        element.setChildIds(childIds);
        element.setDraggable(true);
        element.setResizable(false);
        element.setConnectable(true);
        element.setDeletable(false);
        
        return element;
    }

    private Connection createConnection(String source, String target) {
        Connection connection = new Connection();
        connection.setId(source + "-" + target);
        connection.setSource(source);
        connection.setTarget(target);
        connection.setType("smoothstep");
        connection.setArrowParams(new ArrowParams("arrowclosed"));
        
        return connection;
    }

    private Element findElementById(List<Element> elements, String id) {
        return elements.stream()
                .filter(element -> element.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
}
