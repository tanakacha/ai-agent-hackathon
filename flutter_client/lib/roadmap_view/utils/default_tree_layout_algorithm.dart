// lib/default_tree_layout_algorithm.dart (新規ファイル)
import 'dart:math' as math;

import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/roadmap_view/utils/interface/tree_layout_gorithm.dart';

Map<String, Node> convertListToNodeMap(List<Node> nodes) {
  return {
    for (var node in nodes.where((n) => n.id.isNotEmpty)) node.id: node,
  };
}

class DefaultTreeLayoutAlgorithm implements TreeLayoutAlgorithm {
  @override
  Map<String, Node> calculatePositions({
    required Map<String, Node> nodes,
    required List<Node> rootNodes,
    required double spaceX,
    required double spaceY,
  }) {
    if (nodes.isEmpty) return nodes;
    final localNodes = Map<String, Node>.of(nodes);

    int maxDepth = _calculateMaxDepth(localNodes);
    double currentGlobalY = 0.0;
    for (final rootNode in rootNodes) {
      _positionNodeDFS(
          rootNode.id, 0, currentGlobalY, localNodes, spaceX, spaceY);
      currentGlobalY = _getMaxY(rootNode.id, localNodes) + spaceY * 5;
    }

    // 親の位置を子の中心に合わせて再調整
    for (int i = maxDepth; i >= 0; i--) {
      for (final node in localNodes.values.where(
        (node) => _getDepth(node.id, localNodes) == i,
      )) {
        if (node.childrenIds.isNotEmpty) {
          final reversedChildrenIds = node.childrenIds.reversed.toList();
          double topMostChildY = localNodes[reversedChildrenIds.first]!.y;
          double bottomMostChildY = localNodes[reversedChildrenIds.last]!.y;
          localNodes[node.id] = localNodes[node.id]!
              .copyWith(y: (topMostChildY + bottomMostChildY) / 2);
        }
      }
    }

    return localNodes; // 修正: 更新後のMapを返す
  }
  

  double _positionNodeDFS(String nodeId, int depth, double currentY,
      Map<String, Node> nodes, double spaceX, double spaceY) {
    final node = nodes[nodeId]!;
    // Use copyWith to create a new immutable Node with updated position
    nodes[nodeId] = node.copyWith(x: -depth * spaceX); // 左側に配置

    if (node.childrenIds.isEmpty) {
      nodes[nodeId] = nodes[nodeId]!.copyWith(y: currentY);
      return currentY + spaceY;
    } else {
      double nextY = currentY;
      for (final childId in node.childrenIds.reversed) {
        nextY = _positionNodeDFS(
          childId,
          depth + 1,
          nextY,
          nodes,
          spaceX,
          spaceY,
        );
      }
      nodes[nodeId] = nodes[nodeId]!
          .copyWith(y: currentY); // Temporary, will be adjusted later
      return nextY;
    }
  }

  double _getMaxY(String nodeId, Map<String, Node> nodes) {
    final node = nodes[nodeId]!;
    double maxY = node.y;
    for (final childId in node.childrenIds) {
      maxY = math.max(maxY, _getMaxY(childId, nodes));
    }
    return maxY;
  }

  int _calculateMaxDepth(Map<String, Node> nodes) {
    int maxDepth = 0;
    for (final node in nodes.values) {
      maxDepth = math.max(maxDepth, _getDepth(node.id, nodes));
    }
    return maxDepth;
  }

  int _getDepth(String? nodeId, Map<String, Node> nodes) {
    int depth = 0;
    String? currentId = nodeId;
    while (currentId != null) {
      final node = nodes[currentId];
      if (node == null) break;
      currentId = node.parentId;
      depth++;
    }
    return depth - 1; // Subtract 1 to start depth at 0 for the root node
  }

  Map<String, dynamic> addNodeAndRecalculate({
    required Node newNode,
    required Map<String, Node> nodes,
    required List<Node> rootNodes,
    required double spaceX,
    required double spaceY,
  }) {
    // 1. 新しいnodeをマップに追加（座標は0,0で初期化）
    final updatedNodes = Map<String, Node>.from(nodes);
    updatedNodes[newNode.id] = newNode.copyWith(x: 0.0, y: 0.0);

    // 2. 親子関係を更新
    _updateParentChildRelations(newNode, updatedNodes);

    // 3. ルートノードリストを更新
    final updatedRootNodes = _updateRootNodesList(rootNodes, updatedNodes);

    // 4. 全体のレイアウトを再計算
    calculatePositions(
      nodes: updatedNodes,
      rootNodes: updatedRootNodes,
      spaceX: spaceX,
      spaceY: spaceY,
    );

    return {
      'nodes': updatedNodes,
      'rootNodes': updatedRootNodes,
    };
  }

  /// 親子関係を更新する
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

  /// ルートノードリストを更新する
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

  /// 複数のnodeを一度に追加する場合の関数
  Map<String, dynamic> addMultipleNodesAndRecalculate({
    required List<Node> newNodes,
    required Map<String, Node> nodes,
    required List<Node> rootNodes,
    required double spaceX,
    required double spaceY,
  }) {
    Map<String, Node> updatedNodes = Map<String, Node>.from(nodes);
    List<Node> updatedRootNodes = List<Node>.from(rootNodes);

    // 1. 全ての新しいnodeを追加
    for (final newNode in newNodes) {
      updatedNodes[newNode.id] = newNode.copyWith(x: 0.0, y: 0.0);
    }

    // 2. 全ての親子関係を更新
    for (final newNode in newNodes) {
      _updateParentChildRelations(newNode, updatedNodes);
    }

    // 3. ルートノードリストを更新
    updatedRootNodes = _updateRootNodesList(updatedRootNodes, updatedNodes);

    // 4. 全体のレイアウトを再計算
    calculatePositions(
      nodes: updatedNodes,
      rootNodes: updatedRootNodes,
      spaceX: spaceX,
      spaceY: spaceY,
    );

    return {
      'nodes': updatedNodes,
      'rootNodes': updatedRootNodes,
    };
  }
}
