import 'package:flutter/material.dart';
import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/common/model/road_map.dart';
import 'package:flutter_client/roadmap_view/utils/default_tree_layout_algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client.dart';
import '../api/models/add_child_nodes_request.dart';
import '../api/models/add_child_nodes_response.dart';

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
      _apiClient.dio.get(
        '/roadmap/roadmap/$id',
      ),
      (json) => RoadMap.fromJson(json),
    );
    debugPrint('roadmap: $roadmap');
    final nodes = await _apiClient.handleResponse<List<Node>>(
      _apiClient.dio.get(
        '/roadmap/roadmap/$id/nodes',
      ),
      (json) => (json as List<dynamic>)
          .map((e) => Node.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    roadmap.setNodes(convertListToNodeMap(nodes));
    return roadmap;
  }
}
