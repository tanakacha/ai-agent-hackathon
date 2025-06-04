package com.example.service;

import com.example.dto.RoadmapResponse;
import com.example.dto.RoadmapResponse.*;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
        return createRoadmapFromLLMResponse(goal, deadline, llmResponse);
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
            1. 目標達成のために必要な主要なマイルストーンを3-6個特定する
            2. 各マイルストーンは実現可能で具体的な内容にする
            3. マイルストーン間の論理的な順序を考慮する
            4. 期限から逆算して現実的なスケジュールを提案する
            
            応答は以下のフォーマットで、マイルストーンのタイトルのみを簡潔に列挙してください：
            
            マイルストーン:
            1. [最初のマイルストーン]
            2. [2番目のマイルストーン]
            3. [3番目のマイルストーン]
            4. [4番目のマイルストーン]
            5. [5番目のマイルストーン]
            
            各マイルストーンは15文字以内で簡潔に表現してください。
            """, goal, deadline);
    }

    private RoadmapResponse createRoadmapFromLLMResponse(String goal, String deadline, String llmResponse) {
        List<String> milestones = extractMilestones(llmResponse);
        
        if (milestones.isEmpty()) {
            milestones = createDefaultMilestones(goal);
        }
        
        List<Element> elements = new ArrayList<>();
        double canvasWidth = 800.0;
        double nodeWidth = 150.0;
        double nodeHeight = 80.0;
        double spacing = (canvasWidth - nodeWidth) / Math.max(1, milestones.size() - 1);
        
        // 開始ノード
        Element startElement = createElementWithDefaults(
            "start-node",
            50.0, 150.0,
            120.0, 60.0,
            "開始",
            4294901760L,
            14.0
        );
        elements.add(startElement);
        
        // マイルストーンノードを生成
        String previousId = "start-node";
        for (int i = 0; i < milestones.size(); i++) {
            String milestoneId = "milestone-" + (i + 1);
            double x = 100.0 + (i + 1) * spacing;
            double y = 150.0 + (i % 2 == 0 ? 0 : 50); // ジグザグ配置これはフロントさんに任せる？
            
            Element milestoneElement = createElementWithDefaults(
                milestoneId,
                x, y,
                nodeWidth, nodeHeight,
                milestones.get(i),
                4294944000L,
                12.0
            );
            elements.add(milestoneElement);
            
            addConnection(elements.get(elements.size() - 2), milestoneId);
            previousId = milestoneId;
        }

        Element endElement = createElementWithDefaults(
            "end-node",
            100.0 + (milestones.size() + 1) * spacing, 150.0,
            120.0, 60.0,
            "完了",
            4294934528L,
            14.0
        );
        elements.add(endElement);
        
        if (elements.size() > 1) {
            addConnection(elements.get(elements.size() - 2), endElement.getId());
        }
        
        GridBackgroundParams gridParams = new GridBackgroundParams(
            0.0, 0.0, 1.0, 20.0, 0.7, 5, 4294967295L, 4278190080L
        );
        
        return new RoadmapResponse(
            elements,
            canvasWidth,
            400.0,
            gridParams,
            false,
            0.25,
            0
        );
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
                Pattern pattern = Pattern.compile("^\\d+\\.\\s*(.+)$");
                Matcher matcher = pattern.matcher(line);
                
                if (matcher.find()) {
                    String milestone = matcher.group(1).trim();
                    // 15文字制限を適用
                    if (milestone.length() > 15) {
                        milestone = milestone.substring(0, 12) + "...";
                    }
                    milestones.add(milestone);
                } else if (line.startsWith("-") || line.startsWith("•")) {
                    String milestone = line.substring(1).trim();
                    if (milestone.length() > 15) {
                        milestone = milestone.substring(0, 12) + "...";
                    }
                    milestones.add(milestone);
                }
                
                // 最大6個まで
                if (milestones.size() >= 6) {
                    break;
                }
            }
        }
        
        return milestones;
    }

    private List<String> createDefaultMilestones(String goal) {
        // デフォルトのマイルストーン生成
        List<String> defaults = new ArrayList<>();
        defaults.add("要件定義");
        defaults.add("設計フェーズ");
        defaults.add("開発開始");
        defaults.add("テスト実行");
        defaults.add("最終調整");
        return defaults;
    }

    private Element createElementWithDefaults(String id, double x, double y, 
                                           double width, double height, 
                                           String text, long backgroundColor,
                                           double fontSize) {
        Element element = new Element();
        element.setId(id);
        element.setPositionDx(x);
        element.setPositionDy(y);
        element.setSizeWidth(width);
        element.setSizeHeight(height);
        element.setText(text);
        element.setTextColor(4278190080L);
        element.setFontFamily(null);
        element.setTextSize(fontSize);
        element.setTextIsBold(false);
        element.setKind(0);
        element.setHandlers(Arrays.asList(1, 0, 3, 2));
        element.setHandlerSize(25.0);
        element.setBackgroundColor(backgroundColor);
        element.setBorderColor(4280391411L);
        element.setBorderThickness(3.0);
        element.setElevation(4.0);
        element.setData(null);
        element.setNext(new ArrayList<>());
        element.setDraggable(true);
        element.setResizable(false);
        element.setConnectable(true);
        element.setDeletable(false);
        
        return element;
    }

    private void addConnection(Element fromElement, String toElementId) {
        ArrowParams arrowParams = new ArrowParams(
            1.7, 6.0, 25.0, 4278190080L, null, 1.0,
            1.0, 0.0, -1.0, 0.0
        );
        
        Connection connection = new Connection(
            toElementId,
            arrowParams,
            new ArrayList<>()
        );
        
        fromElement.getNext().add(connection);
    }
}
