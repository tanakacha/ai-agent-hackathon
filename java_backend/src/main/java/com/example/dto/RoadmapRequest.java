package com.example.dto;

import lombok.Data;

@Data
public class RoadmapRequest {
    private String goal;
    private String deadline;
    private UserProfile userProfile;

    @Data
    public static class UserProfile {
        private UserType userType;
        private int availableHoursPerDay;
        private int availableDaysPerWeek;
        private ExperienceLevel experienceLevel;
        private String timezone;
    }

    public enum UserType {
        WORKING_PROFESSIONAL,
        STUDENT,
        FREELANCER,
        RETIRED,
        OTHER
    }

    public enum ExperienceLevel {
        BEGINNER,
        INTERMEDIATE,
        ADVANCED,
        EXPERT
    }
}
