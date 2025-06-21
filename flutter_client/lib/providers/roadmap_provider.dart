// providers/roadmap_provider.dart
import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/common/model/road_map.dart';
import 'package:flutter_client/providers/nodes_provider.dart';
import 'package:flutter_client/services/roadmap_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '_generated/roadmap_provider.g.dart';

@riverpod
class RoadmapNotifier extends _$RoadmapNotifier {
  @override
  Future<RoadMap> build() async {
    // 初期状態では空のロードマップを返すか、もしくは何も返さず null を許容する設計でもOK
    return await _loadRoadmap("map-5678");
  }

  Future<RoadMap> _loadRoadmap(String roadmapId) async {
    final roadmapService = ref.read(roadmapServiceProvider);
    final roadmapData = await roadmapService.fetchRoadMapById(roadmapId);

    ref.read(nodesNotifierProvider.notifier).setNodes(roadmapData.nodes);
    final nodes = ref.read(nodesNotifierProvider);

    return RoadMap(
      id: roadmapId,
      title: roadmapData.title,
      profile: roadmapData.profile,
      objective: roadmapData.objective,
      deadline: roadmapData.deadline,
      createdAt: roadmapData.createdAt,
      updatedAt: roadmapData.updatedAt,
      nodes: nodes,
    );
  }

  List<Node> getRootNodes() {
    final currentState = state;
    if (!currentState.hasValue) return [];

    final nodes = currentState.value!.nodes;

    return nodes.values
        .where((node) =>
            node.parentId == null || !nodes.containsKey(node.parentId))
        .toList();
  }

  List<Node> getNodeList() {
    final currentState = state;
    if (!currentState.hasValue) return [];
    return currentState.value!.nodes.values.toList();
  }

  Future<void> addChildNodesToParent(
      {required String roadmapId, required String parentId}) async {
    state = const AsyncLoading<RoadMap>().copyWithPrevious(state);

    try {
      final roadmapService = ref.read(roadmapServiceProvider);
      final roadmapData = await roadmapService.addChildNodes(
        mapId: roadmapId,
        nodeId: parentId,
      );

      ref.read(nodesNotifierProvider.notifier).addMultipleNodesAndRecalculate(
        newNodes: roadmapData.childNodes,
        spaceX: 120.0,
        spaceY: 100.0,
      );
      final updatedNodes = ref.read(nodesNotifierProvider);

      final currentState = state;
      if (currentState.hasValue) {
        final roadmap = currentState.value!;
        state = AsyncData(RoadMap(
          id: roadmap.id,
          title: roadmap.title,
          profile: roadmap.profile,
          objective: roadmap.objective,
          deadline: roadmap.deadline,
          createdAt: roadmap.createdAt,
          updatedAt: DateTime.now(),
          nodes: updatedNodes,
        ));
      } else {
        throw Exception("Failed to update roadmap: current state is invalid.");
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
