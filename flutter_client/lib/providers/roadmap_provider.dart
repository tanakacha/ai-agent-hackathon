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
    throw UnimplementedError('Call loadRoadmapById to load actual roadmap');
  }

  Future<void> loadRoadmapById(String roadmapId) async {
    state = const AsyncLoading();

    try {
      final roadmapService = ref.read(roadmapServiceProvider);
      final roadmapData = await roadmapService.fetchRoadMapById(roadmapId);

      // ノードの初期化
      ref.read(nodesNotifierProvider.notifier).setNodes(roadmapData.nodes);
      final nodes = ref.read(nodesNotifierProvider);

      state = AsyncData(RoadMap(
        id: roadmapId,
        title: roadmapData.title,
        profile: roadmapData.profile,
        objective: roadmapData.objective,
        deadline: roadmapData.deadline,
        createdAt: roadmapData.createdAt,
        updatedAt: roadmapData.updatedAt,
        nodes: nodes,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
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

  void addChildNodesToParent(
      String roadmapId, String parentId, List<Node> newNodes) {
    final currentState = state;
    if (!currentState.hasValue) return;

    final nodesNotifier = ref.read(nodesNotifierProvider.notifier);

    // 追加する各ノードの親IDをセット
    final updatedNodes = newNodes.map((node) {
      return node.copyWith(parentId: parentId);
    }).toList();

    // ノード追加＋レイアウト再計算
    nodesNotifier.addMultipleNodesAndRecalculate(newNodes: updatedNodes);

    // 現在のロードマップを更新（nodesを再取得）
    final updatedNodesMap = ref.read(nodesNotifierProvider);
    final currentRoadmap = currentState.value!;
    state = AsyncData(currentRoadmap.copyWith(nodes: updatedNodesMap));
  }
}
