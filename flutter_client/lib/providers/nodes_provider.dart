import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../common/model/node.dart';
import '../common/sample_data/node_list.dart';
import '../services/roadmap_service.dart';

part '_generated/nodes_provider.g.dart';

@riverpod
class NodesNotifier extends _$NodesNotifier {
  @override
  Map<String, Node> build() {
    return Map.from(sampleNodes);
  }
  
  void updateNodes(Map<String, Node> newNodes) {
    state = {...state, ...newNodes};
  }
  
  void addNodes(List<Node> newNodes) {
    final newNodesMap = <String, Node>{};
    for (final node in newNodes) {
      newNodesMap[node.id] = node;
    }
    state = {...state, ...newNodesMap};
  }
  
  Future<void> addChildNodesToParent({
    required String mapId,
    required String nodeId,
  }) async {
    try {
      final roadmapService = ref.read(roadmapServiceProvider);
      final response = await roadmapService.addChildNodes(
        mapId: mapId,
        nodeId: nodeId,
      );
      
      // 新しい子ノードにランダムな位置を設定
      final random = Random();
      final nodesWithRandomPositions = response.childNodes.map((node) {
        return node.copyWith(
          x: random.nextDouble() * 800 + 100, // 100-900の範囲でランダム
          y: random.nextDouble() * 600 + 100, // 100-700の範囲でランダム
        );
      }).toList();
      
      // 新しい子ノードを状態に追加
      addNodes(nodesWithRandomPositions);
      
      // 親ノードの子IDリストを更新
      final parentNode = state[nodeId];
      if (parentNode != null) {
        final newChildIds = [...parentNode.childrenIds];
        for (final childNode in nodesWithRandomPositions) {
          if (!newChildIds.contains(childNode.id)) {
            newChildIds.add(childNode.id);
          }
        }
        
        final updatedParent = parentNode.copyWith(childrenIds: newChildIds);
        state = {...state, nodeId: updatedParent};
      }
    } catch (e) {
      // エラーハンドリング - 実際のアプリではより詳細なエラー処理が必要
      rethrow;
    }
  }

  Future<void> completeNode({
    required String mapId,
    required String nodeId,
  }) async {
    try {
      final roadmapService = ref.read(roadmapServiceProvider);
      final response = await roadmapService.completeNode(
        mapId: mapId,
        nodeId: nodeId,
      );
      
      if (response.node != null) {
        final completedNode = response.node!;
        state = {...state, nodeId: completedNode};
      }
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
class SelectedNodeNotifier extends _$SelectedNodeNotifier {
  @override
  String? build() {
    return null;
  }
  
  void selectNode(String nodeId) {
    state = nodeId;
  }
  
  void clearSelection() {
    state = null;
  }
}
