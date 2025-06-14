package com.example.service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dto.DetailedRoadmapRequest;
import com.example.dto.DetailedRoadmapResponse;
import com.example.dto.Node;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;

@Service
public class DetailedRoadmapGenerationService {

    private final GenerativeModel generativeModel;
    private final NodeService nodeService;
    private final RoadMapService roadMapService;

    @Autowired
    public DetailedRoadmapGenerationService(GenerativeModel generativeModel,
                                           NodeService nodeService,
                                           RoadMapService roadMapService) {
        this.generativeModel = generativeModel;
        this.nodeService = nodeService;
        this.roadMapService = roadMapService;
    }

    public DetailedRoadmapResponse generateDetailedRoadmap(DetailedRoadmapRequest request) {
        try {
            String mapId = generateMapId();
            String llmResponse = generateRoadmapFromLLM(request);
            
            List<Node> nodes = createDetailedNodesFromLLMResponse(llmResponse, mapId, request);

            roadMapService.createRoadMap(mapId, request.getGoal(), request.getDeadline());

            List<Node> savedNodes = nodeService.createNodes(nodes);
            
            return new DetailedRoadmapResponse(mapId, savedNodes);
        } catch (Exception e) {
            throw new RuntimeException("詳細ロードマップ生成中にエラーが発生しました: " + e.getMessage(), e);
        }
    }

    private String generateRoadmapFromLLM(DetailedRoadmapRequest request) {
        String prompt = createRoadmapPrompt(request);
        
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

    private String createRoadmapPrompt(DetailedRoadmapRequest request) {
        String userProfileInfo = buildUserProfileInfo(request.getUserProfile());
        LocalDate currentDate = LocalDate.now();
        
        return String.format("""
            あなたはプロジェクトマネージャーです。以下の情報を基にロードマップを作成してください。
            
            現在の日付: %s
            目標: %s
            期限: %s
            
            ユーザープロファイル:
            %s
            
            以下の要件に従って実用的なロードマップを作成してください：
            1. 目標達成のために必要な主要なマイルストーンを3-6個特定する
            2. 各マイルストーンは実現可能で具体的な内容にする
            3. マイルストーン間の論理的な順序を考慮する
            4. 現在の日付(%s)から期限(%s)までの期間を逆算して現実的なスケジュールを提案する
            5. ユーザーの利用可能時間と経験レベルとタスクの難易度を考慮してスケジュールを調整する
            
            応答は以下のフォーマットで、マイルストーンのタイトルと期日を含めて列挙してください：
            
            マイルストーン:
            1. [最初のマイルストーン] - [YYYY-MM-DD]
            2. [2番目のマイルストーン] - [YYYY-MM-DD]
            3. [3番目のマイルストーン] - [YYYY-MM-DD]
            4. [4番目のマイルストーン] - [YYYY-MM-DD]
            5. [5番目のマイルストーン] - [YYYY-MM-DD]
            
            各マイルストーンは15文字以内で簡潔に表現し、期日は最終期限(%s)以前に設定してください。
            """, currentDate, request.getGoal(), request.getDeadline(), userProfileInfo, currentDate, request.getDeadline(), request.getDeadline());
    }

    private String buildUserProfileInfo(DetailedRoadmapRequest.UserProfile userProfile) {
        if (userProfile == null) {
            return "ユーザープロファイル情報なし";
        }
        
        return String.format("""
            - ユーザータイプ: %s
            - 1日の利用可能時間: %d時間
            - 週の利用可能日数: %d日
            - 経験レベル: %s
            - タイムゾーン: %s
            """,
            userProfile.getUserType() != null ? userProfile.getUserType().toString() : "不明",
            userProfile.getAvailableHoursPerDay(),
            userProfile.getAvailableDaysPerWeek(),
            userProfile.getExperienceLevel() != null ? userProfile.getExperienceLevel().toString() : "不明",
            userProfile.getTimezone() != null ? userProfile.getTimezone() : "不明"
        );
    }

    private String generateMapId() {
        return "map-" + UUID.randomUUID().toString().substring(0, 8);
    }

    private List<Node> createDetailedNodesFromLLMResponse(String llmResponse, String mapId, DetailedRoadmapRequest request) {
        List<MilestoneWithDeadline> milestones = extractMilestonesWithDeadlines(llmResponse);
        
        if (milestones.isEmpty()) {
            milestones = createDefaultMilestonesWithDeadlines(request);
        }
        
        List<Node> nodes = new ArrayList<>();
        Date now = new Date();

        Node rootNode = createDetailedNode(
            "node-1",
            mapId,
            "プロジェクト開始",
            "詳細なプロジェクトの開始点",
            "Root",
            null,
            new ArrayList<>(),
            now,
            null,
            0
        );
        nodes.add(rootNode);

        String previousId = "node-1";
        for (int i = 0; i < milestones.size(); i++) {
            String nodeId = "node-" + (i + 2);
            MilestoneWithDeadline milestone = milestones.get(i);

            Date dueDate = null;
            if (milestone.getDeadline() != null) {
                dueDate = Date.from(milestone.getDeadline().atStartOfDay(ZoneId.systemDefault()).toInstant());
            }

            int duration = calculateDuration(i, milestones, request);
            
            Node milestoneNode = createDetailedNode(
                nodeId,
                mapId,
                milestone.getTitle(),
                milestone.getTitle() + "を達成する",
                "Task",
                previousId,
                new ArrayList<>(),
                now,
                dueDate,
                duration
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

    private int calculateDuration(int index, List<MilestoneWithDeadline> milestones, DetailedRoadmapRequest request) {

        if (request.getUserProfile() != null) {
            int hoursPerDay = request.getUserProfile().getAvailableHoursPerDay();
            int daysPerWeek = request.getUserProfile().getAvailableDaysPerWeek();
            
            int baseHours = switch (request.getUserProfile().getExperienceLevel()) {
                case BEGINNER -> 40;
                case INTERMEDIATE -> 20;
                case ADVANCED -> 15;
                case EXPERT -> 10;
                default -> 25;
            };

            int weeklyHours = hoursPerDay * daysPerWeek;

            return Math.max(1, (baseHours + weeklyHours - 1) / weeklyHours);
        }
        
        return 7;
    }

    private Node createDetailedNode(String id, String mapId, String title, String description, 
                                   String nodeType, String parentId, List<String> childrenIds, 
                                   Date now, Date dueDate, int duration) {
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
        node.setDue_at(dueDate);
        node.setFinished_at(null);
        node.setDuration(duration);
        node.setProgress_rate(0);
        
        return node;
    }

    private Node findNodeById(List<Node> nodes, String id) {
        return nodes.stream()
                .filter(node -> node.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    private List<MilestoneWithDeadline> extractMilestonesWithDeadlines(String llmResponse) {
        List<MilestoneWithDeadline> milestones = new ArrayList<>();

        String[] lines = llmResponse.split("\n");
        boolean inMilestoneSection = false;
        
        for (String line : lines) {
            line = line.trim();
            
            if (line.contains("マイルストーン:") || line.contains("Milestone")) {
                inMilestoneSection = true;
                continue;
            }
            
            if (inMilestoneSection && !line.isEmpty()) {
                Pattern pattern = Pattern.compile("^\\d+\\.\\s*(.+?)\\s*-\\s*(\\d{4}-\\d{2}-\\d{2})$");
                Matcher matcher = pattern.matcher(line);
                
                if (matcher.find()) {
                    String title = matcher.group(1).trim();
                    String dateStr = matcher.group(2).trim();
                    
                    // 15文字制限を適用
                    if (title.length() > 15) {
                        title = title.substring(0, 12) + "...";
                    }
                    
                    LocalDate deadline = parseDeadline(dateStr);
                    milestones.add(new MilestoneWithDeadline(title, deadline));
                }
                
                // 最大6個まで
                if (milestones.size() >= 6) {
                    break;
                }
            }
        }
        
        return milestones;
    }

    private List<MilestoneWithDeadline> createDefaultMilestonesWithDeadlines(DetailedRoadmapRequest request) {
        List<MilestoneWithDeadline> defaults = new ArrayList<>();
        LocalDate finalDeadline = parseDeadline(request.getDeadline());
        LocalDate currentDate = LocalDate.now();
        
        long totalDays = ChronoUnit.DAYS.between(currentDate, finalDeadline);
        int milestoneCount = 5;
        long daysBetweenMilestones = totalDays / (milestoneCount + 1);
        
        String[] defaultTitles = {"要件定義", "設計フェーズ", "開発開始", "テスト実行", "最終調整"};
        
        for (int i = 0; i < defaultTitles.length; i++) {
            LocalDate milestoneDeadline = currentDate.plusDays((i + 1) * daysBetweenMilestones);
            defaults.add(new MilestoneWithDeadline(defaultTitles[i], milestoneDeadline));
        }
        
        return defaults;
    }

    private LocalDate parseDeadline(String deadline) {
        try {
            return LocalDate.parse(deadline, DateTimeFormatter.ISO_LOCAL_DATE);
        } catch (Exception e) {
            return LocalDate.now().plusDays(30);
        }
    }

    private static class MilestoneWithDeadline {
        private final String title;
        private final LocalDate deadline;

        public MilestoneWithDeadline(String title, LocalDate deadline) {
            this.title = title;
            this.deadline = deadline;
        }

        public String getTitle() {
            return title;
        }

        public LocalDate getDeadline() {
            return deadline;
        }
    }
}
