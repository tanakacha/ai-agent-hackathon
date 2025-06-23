package com.example.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateUserWithProfileRequest {
    private String uid;
    private String nickname;
    private int age;
    private UserType userType;
    private int availableHoursPerDay;
    private int availableDaysPerWeek;
    private ExperienceLevel experienceLevel;
    
    public enum UserType {
        STUDENT, PROFESSIONAL, FREELANCER, HOBBYIST
    }
    
    public enum ExperienceLevel {
        BEGINNER, INTERMEDIATE, ADVANCED, EXPERT
    }
}
