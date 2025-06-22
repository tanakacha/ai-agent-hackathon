import 'package:flutter_client/roadmap_view/utils/default_tree_layout_algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/model/node.dart';
import '../common/sample_data/node_list.dart';
import '../services/roadmap_service.dart';

part '_generated/nodes_provider.g.dart';

@Riverpod(keepAlive: true)
class NodesNotifier extends _$NodesNotifier {
  final layout = DefaultTreeLayoutAlgorithm();
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

  Map<String, dynamic> addMultipleNodesAndRecalculate({
    required List<Node> newNodes,
    double spaceX = 200.0,
    double spaceY = 100.0,
  }) {
    // 現在のルートノードを取得
    final rootNodes = _getRootNodes(state);

    Map<String, Node> updatedNodes = Map<String, Node>.from(state);

    // 1. 全ての新しいnodeを追加
    for (final newNode in newNodes) {
      updatedNodes[newNode.id] = newNode.copyWith(x: 0.0, y: 0.0);
    }

    // 2. 全ての親子関係を更新
    for (final newNode in newNodes) {
      _updateParentChildRelations(newNode, updatedNodes);
    }

    // 3. ルートノードリストを更新
    final updatedRootNodes = _updateRootNodesList(rootNodes, updatedNodes);

    // 4. 全体のレイアウトを再計算
    layout.calculatePositions(
      nodes: updatedNodes,
      rootNodes: updatedRootNodes,
      spaceX: spaceX,
      spaceY: spaceY,
    );

    // 状態を更新
    state = updatedNodes;

    return {
      'nodes': updatedNodes,
      'rootNodes': updatedRootNodes,
    };
  }

  List<Node> _updateRootNodesList(
      List<Node> rootNodes, Map<String, Node> nodes) {
    final updatedRootNodes = List<Node>.from(rootNodes);

    // 新しく追加されたnodeがルートノードかチェック
    for (final node in nodes.values) {
      final isRoot = node.parentId == null || !nodes.containsKey(node.parentId);
      final isAlreadyInRootList =
          updatedRootNodes.any((root) => root.id == node.id);

      if (isRoot && !isAlreadyInRootList) {
        updatedRootNodes.add(node);
      } else if (!isRoot && isAlreadyInRootList) {
        // ルートでなくなったnodeを削除
        updatedRootNodes.removeWhere((root) => root.id == node.id);
      }
    }

    return updatedRootNodes;
  }

  void _updateParentChildRelations(Node newNode, Map<String, Node> nodes) {
    // 親ノードに新しいnodeを子として追加
    if (newNode.parentId != null && nodes.containsKey(newNode.parentId)) {
      final parentNode = nodes[newNode.parentId]!;
      if (!parentNode.childrenIds.contains(newNode.id)) {
        final updatedChildrenIds = List<String>.from(parentNode.childrenIds)
          ..add(newNode.id);
        nodes[newNode.parentId!] =
            parentNode.copyWith(childrenIds: updatedChildrenIds);
      }
    }

    // 子ノードたちの親を新しいnodeに設定
    for (final childId in newNode.childrenIds) {
      if (nodes.containsKey(childId)) {
        final childNode = nodes[childId]!;
        nodes[childId] = childNode.copyWith(parentId: newNode.id);
      }
    }
  }

  List<Node> _getRootNodes(Map<String, Node> nodes) {
    return nodes.values
        .where((node) =>
            node.parentId == null || !nodes.containsKey(node.parentId))
        .toList();
  }

  

  void setNodes(Map<String, Node> nodeMap) {
    _recalculateAndSetState(nodeMap);
  }

  void _recalculateAndSetState(
    Map<String, Node> currentNodes, {
    double spaceX = 120.0,
    double spaceY = 100.0,
  }) {
    final rootNodes = _getRootNodes(currentNodes);
    layout.calculatePositions(
      nodes:
          currentNodes, // This map is modified in-place by calculatePositions
      rootNodes: rootNodes,
      spaceX: spaceX,
      spaceY: spaceY,
    );
    state = Map<String, Node>.from(
        currentNodes); // Update state with positioned nodes
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
