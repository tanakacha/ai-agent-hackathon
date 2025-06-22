import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/common/model/road_map.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client.dart';
import '../api/models/add_child_nodes_request.dart';
import '../api/models/add_child_nodes_response.dart';
import '../api/models/detailed_roadmap_response.dart';
import '../auth/repository/user_profile_dto.dart';

part '_generated/roadmap_service.g.dart';

@riverpod
RoadmapService roadmapService(RoadmapServiceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RoadmapService(apiClient);
}

class RoadmapService {
  final ApiClient _apiClient;

  RoadmapService(this._apiClient);

  Future<AddChildNodesResponse> addChildNodes({
    required String mapId,
    required String nodeId,
  }) async {
    final request = AddChildNodesRequest(
      mapId: mapId,
      nodeId: nodeId,
    );

    return _apiClient.handleResponse(
      _apiClient.dio.post(
        '/api/roadmap/add-child-nodes',
        data: request.toJson(),
      ),
      (json) => AddChildNodesResponse.fromJson(json),
    );
  }

  Future<RoadMap> fetchRoadMapById(String id) async {
    final roadmap = await _apiClient.handleResponse(
      _apiClient.dio.get('/api/roadmap/roadmap/$id'),
      (json) => RoadMap.fromJson(json),
    );
    final nodeJsonList = await _apiClient.handleResponse(
      _apiClient.dio.get('/api/roadmap/roadmap/$id/nodes'),
      (json) => json as List<dynamic>? ?? [],
    );
    final nodes = nodeJsonList
        .whereType<Map<String, dynamic>>()
        .map((e) => Node.fromJson(e))
        .toList();
    final nodeMap = listToNodeMap(nodes);

    final updatedRoadmap = roadmap.setNodes(nodeMap);

    debugPrint('updatedRoadmap.nodes: ${updatedRoadmap.nodes}');
    return updatedRoadmap;
  }

  Future<DetailedRoadmapResponse> createDetailedRoadmapWithUser({
    required String userId,
    required String goal,
    required String deadline,
    required UserType userType,
    required int availableHoursPerDay,
    required int availableDaysPerWeek,
    required ExperienceLevel experienceLevel,
  }) async {
    final request = CreateDetailedRoadmapRequest(
      userId: userId,
      goal: goal,
      deadline: deadline,
      userType: userType,
      availableHoursPerDay: availableHoursPerDay,
      availableDaysPerWeek: availableDaysPerWeek,
      experienceLevel: experienceLevel,
    );

    // ロードマップ作成は特に時間がかかるため、より長いタイムアウトを設定
    return _apiClient.handleResponse(
      _apiClient.dio.post(
        '/api/roadmap/create-with-user',
        data: request.toJson(),
        options: Options(
          receiveTimeout: const Duration(minutes: 10), // ロードマップ作成用に10分に延長
          sendTimeout: const Duration(minutes: 3),     // 送信タイムアウトを3分に延長
        ),
      ),
      (json) => DetailedRoadmapResponse.fromJson(json),
    );
  }
}
