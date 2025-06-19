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

            RoadmapInfo roadmapInfo = extractRoadmapInfoFromLLMResponse(llmResponse);
            if (roadmapInfo.getMilestones().isEmpty()) {
                roadmapInfo = createDefaultRoadmapInfo(request);
            }

            List<Node> nodes = createDetailedNodesFromLLMResponse(llmResponse, mapId, request);

            String profileInfo = buildUserProfileForStorage(request.getUserProfile());

            roadMapService.createRoadMapWithDetails(mapId, roadmapInfo.getTitle(), request.getGoal(), profileInfo, request.getDeadline());

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
        LocalDate deadline = parseDeadline(request.getDeadline());
        long totalDays = ChronoUnit.DAYS.between(currentDate, deadline);
        
        return String.format("""
            あなたはプロジェクトマネージャーです。以下の情報を基に詳細なロードマップを作成してください。
            
            現在の日付: %s
            目標: %s
            期限: %s
            利用可能期間: %d日
            
            ユーザープロファイル:
            %s
            
            以下の要件に従って実用的なロードマップを作成してください：
            1. 利用可能期間（%d日）とユーザーの経験レベル・利用可能時間を考慮して、コンテンツ量を適切に調整する
            2. 経験レベルが低い場合は基礎的な内容を多めに、高い場合は高度な内容に集中する
            3. 利用可能時間が少ない場合は、重要なマイルストーンに絞り込む
            4. 目標達成のために必要な主要なマイルストーンを3-6個特定する
            5. 各マイルストーンは実現可能で具体的な内容にする
            6. マイルストーン間の論理的な順序を考慮する
            7. 現在の日付から期限までの期間を逆算して現実的なスケジュールを提案する
            8. ユーザーの利用可能時間と経験レベルを考慮してスケジュールと所要時間を調整する
            
            応答は以下のフォーマットで出力してください：
            
            ロードマップタイトル: [目標を端的に表現した「〜の道」形式のタイトル]
            
            マイルストーン:
            1. タイトル: [マイルストーンタイトル] | 説明: [具体的な説明] | 期日: [YYYY-MM-DD] | 所要週数: [数値]
            2. タイトル: [マイルストーンタイトル] | 説明: [具体的な説明] | 期日: [YYYY-MM-DD] | 所要週数: [数値]
            3. タイトル: [マイルストーンタイトル] | 説明: [具体的な説明] | 期日: [YYYY-MM-DD] | 所要週数: [数値]
            
            各マイルストーンのタイトルは10文字以内で簡潔に表現し、期日は最終期限（%s）以前に設定してください。
            所要週数は、ユーザーの利用可能時間（1日%d時間、週%d日）と経験レベル（%s）を考慮して現実的に設定してください。
            """, 
            currentDate, 
            request.getGoal(), 
            request.getDeadline(), 
            totalDays,
            userProfileInfo, 
            totalDays,
            request.getDeadline(),
            request.getUserProfile() != null ? request.getUserProfile().getAvailableHoursPerDay() : 2,
            request.getUserProfile() != null ? request.getUserProfile().getAvailableDaysPerWeek() : 3,
            request.getUserProfile() != null && request.getUserProfile().getExperienceLevel() != null ? 
                request.getUserProfile().getExperienceLevel().toString() : "不明"
        );
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
            """,
            userProfile.getUserType() != null ? userProfile.getUserType().toString() : "不明",
            userProfile.getAvailableHoursPerDay(),
            userProfile.getAvailableDaysPerWeek(),
            userProfile.getExperienceLevel() != null ? userProfile.getExperienceLevel().toString() : "不明"
        );
    }

    private String buildUserProfileForStorage(DetailedRoadmapRequest.UserProfile userProfile) {
        if (userProfile == null) {
            return "{}";
        }
        
        return String.format("""
            {
                "userType": "%s",
                "availableHoursPerDay": %d,
                "availableDaysPerWeek": %d,
                "experienceLevel": "%s"
            }
            """,
            userProfile.getUserType() != null ? userProfile.getUserType().toString() : "UNKNOWN",
            userProfile.getAvailableHoursPerDay(),
            userProfile.getAvailableDaysPerWeek(),
            userProfile.getExperienceLevel() != null ? userProfile.getExperienceLevel().toString() : "UNKNOWN"
        ).replaceAll("\\s+", " ").trim();
    }

    private String generateMapId() {
        return "map-" + UUID.randomUUID().toString().substring(0, 8);
    }

    private List<Node> createDetailedNodesFromLLMResponse(String llmResponse, String mapId, DetailedRoadmapRequest request) {
        RoadmapInfo roadmapInfo = extractRoadmapInfoFromLLMResponse(llmResponse);
        
        if (roadmapInfo.getMilestones().isEmpty()) {
            roadmapInfo = createDefaultRoadmapInfo(request);
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
        List<MilestoneWithDeadline> milestones = roadmapInfo.getMilestones();
        
        for (int i = 0; i < milestones.size(); i++) {
            String nodeId = "node-" + (i + 2);
            MilestoneWithDeadline milestone = milestones.get(i);

            Date dueDate = null;
            if (milestone.getDeadline() != null) {
                dueDate = Date.from(milestone.getDeadline().atStartOfDay(ZoneId.systemDefault()).toInstant());
            }

            Node milestoneNode = createDetailedNode(
                nodeId,
                mapId,
                milestone.getTitle(),
                milestone.getDescription(),
                "Task",
                previousId,
                new ArrayList<>(),
                now,
                dueDate,
                milestone.getDurationWeeks()
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

    private RoadmapInfo extractRoadmapInfoFromLLMResponse(String llmResponse) {
        String[] lines = llmResponse.split("\n");
        String roadmapTitle = null;
        List<MilestoneWithDeadline> milestones = new ArrayList<>();
        boolean inMilestoneSection = false;
        
        for (String line : lines) {
            line = line.trim();
            
            if (line.startsWith("ロードマップタイトル:") || line.startsWith("タイトル:")) {
                roadmapTitle = line.substring(line.indexOf(":") + 1).trim();
                continue;
            }

            if (line.contains("マイルストーン:") || line.contains("Milestone")) {
                inMilestoneSection = true;
                continue;
            }

            if (inMilestoneSection && !line.isEmpty()) {
                Pattern pattern = Pattern.compile("^\\d+\\.\\s*タイトル:\\s*(.+?)\\s*\\|\\s*説明:\\s*(.+?)\\s*\\|\\s*期日:\\s*(\\d{4}-\\d{2}-\\d{2})\\s*\\|\\s*所要週数:\\s*(\\d+)$");
                Matcher matcher = pattern.matcher(line);
                
                if (matcher.find()) {
                    String title = matcher.group(1).trim();
                    String description = matcher.group(2).trim();
                    String dateStr = matcher.group(3).trim();
                    int weeks = Integer.parseInt(matcher.group(4).trim());
                    
                    LocalDate deadline = parseDeadline(dateStr);
                    milestones.add(new MilestoneWithDeadline(title, description, deadline, weeks));
                }
                
                // 最大6個まで
                if (milestones.size() >= 6) {
                    break;
                }
            }
        }
        
        if (roadmapTitle == null || roadmapTitle.isEmpty()) {
            roadmapTitle = "目標達成への道";
        }
        
        return new RoadmapInfo(roadmapTitle, milestones);
    }

    private RoadmapInfo createDefaultRoadmapInfo(DetailedRoadmapRequest request) {
        List<MilestoneWithDeadline> defaults = new ArrayList<>();
        LocalDate finalDeadline = parseDeadline(request.getDeadline());
        LocalDate currentDate = LocalDate.now();
        
        long totalDays = ChronoUnit.DAYS.between(currentDate, finalDeadline);
        int milestoneCount = 5;
        long daysBetweenMilestones = totalDays / (milestoneCount + 1);
        
        String[] defaultTitles = {"要件定義", "設計フェーズ", "開発開始", "テスト実行", "最終調整"};
        String[] defaultDescriptions = {
            "プロジェクトの要件を明確に定義し、目標を設定する",
            "システムやプロセスの設計を行い、実装計画を立てる", 
            "実際の開発作業を開始し、基本機能を実装する",
            "実装した機能のテストを行い、問題を修正する",
            "最終的な調整とドキュメント作成を行う"
        };
        
        for (int i = 0; i < defaultTitles.length; i++) {
            LocalDate milestoneDeadline = currentDate.plusDays((i + 1) * daysBetweenMilestones);
            int defaultWeeks = Math.max(1, (int)(daysBetweenMilestones / 7));
            defaults.add(new MilestoneWithDeadline(
                defaultTitles[i], 
                defaultDescriptions[i], 
                milestoneDeadline, 
                defaultWeeks
            ));
        }
        
        String defaultTitle = request.getGoal() + "達成への道";
        return new RoadmapInfo(defaultTitle, defaults);
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
        private final String description;
        private final LocalDate deadline;
        private final int durationWeeks;

        public MilestoneWithDeadline(String title, String description, LocalDate deadline, int durationWeeks) {
            this.title = title;
            this.description = description;
            this.deadline = deadline;
            this.durationWeeks = durationWeeks;
        }

        public String getTitle() {
            return title;
        }

        public String getDescription() {
            return description;
        }

        public LocalDate getDeadline() {
            return deadline;
        }

        public int getDurationWeeks() {
            return durationWeeks;
        }
    }

    private static class RoadmapInfo {
        private final String title;
        private final List<MilestoneWithDeadline> milestones;

        public RoadmapInfo(String title, List<MilestoneWithDeadline> milestones) {
            this.title = title;
            this.milestones = milestones;
        }

        public String getTitle() {
            return title;
        }

        public List<MilestoneWithDeadline> getMilestones() {
            return milestones;
        }
    }
}
