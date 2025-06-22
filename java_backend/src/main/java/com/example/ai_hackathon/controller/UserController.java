package com.example.ai_hackathon.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.dto.CheckUserMapRequest;
import com.example.dto.CheckUserMapResponse;
import com.example.dto.CreateUserRequest;
import com.example.dto.CreateUserResponse;
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
}
