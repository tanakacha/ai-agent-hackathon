package com.example.ai_hackathon.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.dto.CheckUserMapRequest;
import com.example.dto.CheckUserMapResponse;
import com.example.dto.CreateUserRequest;
import com.example.dto.CreateUserResponse;
import com.example.dto.CreateUserWithProfileRequest;
import com.example.dto.CreateUserWithProfileResponse;
import com.example.dto.UserMapsListRequest;
import com.example.dto.UserMapsListResponse;
import com.example.model.User;
import com.example.service.UserService;

@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/all")
    public List<User> getUsers() throws Exception {
        return userService.getAllUsers();
    }

    @PostMapping("/create")
    public CreateUserResponse createUser(@RequestBody CreateUserRequest request) {
        try {
            String userId = userService.createUserWithUID(request.getUid(), request.getEmail());
            CreateUserResponse response = new CreateUserResponse();
            response.setId(userId);
            response.setMessage("ユーザーを正常に作成しました");
            return response;
        } catch (Exception e) {
            CreateUserResponse errorResponse = new CreateUserResponse();
            errorResponse.setMessage("ユーザー作成中にエラーが発生しました: " + e.getMessage());
            return errorResponse;
        }
    }

    @PostMapping("/create-with-profile")
    public CreateUserWithProfileResponse createUserWithProfile(@RequestBody CreateUserWithProfileRequest request) {
        try {
            String userId = userService.createUserWithProfile(
                request.getUid(),
                request.getNickname(),
                request.getAge(),
                request.getUserType().toString(),
                request.getAvailableHoursPerDay(),
                request.getAvailableDaysPerWeek(),
                request.getExperienceLevel().toString()
            );
            CreateUserWithProfileResponse response = new CreateUserWithProfileResponse();
            response.setUid(userId);
            response.setMessage("プロファイル付きユーザーを正常に作成しました");
            return response;
        } catch (Exception e) {
            CreateUserWithProfileResponse errorResponse = new CreateUserWithProfileResponse();
            errorResponse.setMessage("プロファイル付きユーザー作成中にエラーが発生しました: " + e.getMessage());
            return errorResponse;
        }
    }

    @PostMapping("/check-map")
    public CheckUserMapResponse checkUserMap(@RequestBody CheckUserMapRequest request) {
        try {
            boolean hasMap = userService.checkUserMapExists(request.getUserId());
            CheckUserMapResponse response = new CheckUserMapResponse();
            response.setHasMap(hasMap);
            
            if (hasMap) {
                String mapId = userService.getUserMapId(request.getUserId());
                response.setMapId(mapId);
                response.setMessage("ユーザーのマップが見つかりました");
            } else {
                response.setMessage("ユーザーのマップが見つかりません");
            }
            
            return response;
        } catch (Exception e) {
            CheckUserMapResponse errorResponse = new CheckUserMapResponse();
            errorResponse.setHasMap(false);
            errorResponse.setMessage("マップ確認中にエラーが発生しました: " + e.getMessage());
            return errorResponse;
        }
    }

    @PostMapping("/maps")
    public UserMapsListResponse getUserMaps(@RequestBody UserMapsListRequest request) {
        try {
            List<Map<String, Object>> mapsData = userService.getUserMaps(request.getUserId());
            List<UserMapsListResponse.MapSummary> mapSummaries = new ArrayList<>();
            
            for (Map<String, Object> mapData : mapsData) {
                UserMapsListResponse.MapSummary summary = new UserMapsListResponse.MapSummary();
                summary.setMapId((String) mapData.get("mapId"));
                summary.setTitle((String) mapData.get("title"));
                summary.setObjective((String) mapData.get("objective"));
                Date deadline = (Date) mapData.get("deadline");
                summary.setDeadline(deadline != null ? deadline.toString() : null);
                mapSummaries.add(summary);
            }
            
            UserMapsListResponse response = new UserMapsListResponse();
            response.setMaps(mapSummaries);
            response.setMessage("マップ一覧を正常に取得しました");
            return response;
        } catch (Exception e) {
            UserMapsListResponse errorResponse = new UserMapsListResponse();
            errorResponse.setMessage("マップ一覧取得中にエラーが発生しました: " + e.getMessage());
            return errorResponse;
        }
    }
}
