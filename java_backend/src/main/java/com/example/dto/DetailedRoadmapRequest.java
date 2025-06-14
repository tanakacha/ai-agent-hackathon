package com.example.dto;

import lombok.Data;

@Data
public class DetailedRoadmapRequest {
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
        
        public enum UserType {
            STUDENT, PROFESSIONAL, FREELANCER, HOBBYIST
        }
        
        public enum ExperienceLevel {
            BEGINNER, INTERMEDIATE, ADVANCED, EXPERT
        }
    }
}
