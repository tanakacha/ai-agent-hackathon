import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../api/models/add_child_nodes_request.dart';
import '../api/models/add_child_nodes_response.dart';
import '../api/models/complete_node_request.dart';
import '../api/models/complete_node_response.dart';

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

  Future<CompleteNodeResponse> completeNode({
    required String mapId,
    required String nodeId,
  }) async {
    final request = CompleteNodeRequest(
      mapId: mapId,
      nodeId: nodeId,
    );
    
    return _apiClient.handleResponse(
      _apiClient.dio.post(
        '/api/roadmap/nodes/complete',
        data: request.toJson(),
      ),
      (json) => CompleteNodeResponse.fromJson(json),
    );
  }
}
