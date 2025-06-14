package com.example.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dto.DetailedRoadmapRequest;
import com.example.dto.DetailedRoadmapResponse;
import com.example.dto.DetailedRoadmapResponse.Element;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;

@Service
public class DetailedRoadmapGenerationService {

    private final GenerativeModel generativeModel;

    @Autowired
    public DetailedRoadmapGenerationService(GenerativeModel generativeModel) {
        this.generativeModel = generativeModel;
    }

    public DetailedRoadmapResponse generateDetailedRoadmap(DetailedRoadmapRequest request) {
        String llmResponse = generateRoadmapFromLLM(request);
        
        // LLMレスポンスからロードマップデータを生成
        return createRoadmapFromLLMResponse(request, llmResponse);
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

    private DetailedRoadmapResponse createRoadmapFromLLMResponse(DetailedRoadmapRequest request, String llmResponse) {
        List<MilestoneWithDeadline> milestones = extractMilestonesWithDeadlines(llmResponse);
        
        if (milestones.isEmpty()) {
            milestones = createDefaultMilestonesWithDeadlines(request);
        }
        
        List<Element> elements = new ArrayList<>();
        
        // 開始ノード
        Element startElement = createElementWithDefaults(
            "start-node",
            "開始",
            null,
            1, // start node
            new ArrayList<>(), // no parents
            new ArrayList<>()  // children will be added
        );
        elements.add(startElement);
        
        // マイルストーンノードを生成
        String previousId = "start-node";
        for (int i = 0; i < milestones.size(); i++) {
            String milestoneId = "milestone-" + (i + 1);
            MilestoneWithDeadline milestone = milestones.get(i);
            
            List<String> parentIds = new ArrayList<>();
            parentIds.add(previousId);
            
            Element milestoneElement = createElementWithDefaults(
                milestoneId,
                milestone.getTitle(),
                milestone.getDeadline(),
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
            
            previousId = milestoneId;
        }

        // 完了ノード
        List<String> endParentIds = new ArrayList<>();
        endParentIds.add(previousId);
        
        Element endElement = createElementWithDefaults(
            "end-node",
            "完了",
            parseDeadline(request.getDeadline()),
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
        
        return new DetailedRoadmapResponse(elements);
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
        if (deadline == null) {
            return LocalDate.now().plusMonths(1); // デフォルト
        }
        
        try {
            return LocalDate.parse(deadline, DateTimeFormatter.ISO_LOCAL_DATE);
        } catch (Exception e) {
            try {
                return LocalDate.parse(deadline, DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            } catch (Exception e2) {
                return LocalDate.now().plusMonths(1); // パースできない場合のデフォルト
            }
        }
    }

    private Element createElementWithDefaults(String id, String text, LocalDate deadline,
                                           int kind, List<String> parentIds, List<String> childIds) {
        Element element = new Element();
        element.setId(id);
        element.setText(text);
        element.setDeadline(deadline);
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

    private Element findElementById(List<Element> elements, String id) {
        return elements.stream()
                .filter(element -> element.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // Inner class for milestone with deadline
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
