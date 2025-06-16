// lib/default_tree_layout_algorithm.dart (新規ファイル)
import 'dart:math' as math;

import 'package:flutter_client/roadmap_view/utils/interface/tree_layout_gorithm.dart';
import 'package:flutter_client/common/model/node.dart';

class DefaultTreeLayoutAlgorithm implements TreeLayoutAlgorithm {
  @override
  void calculatePositions({
    required Map<int, Node> nodes,
    required List<Node> rootNodes,
    required double spaceX,
    required double spaceY,
  }) {
    if (nodes.isEmpty) return;

    // 1. Calculate depths
    int maxDepth = _calculateMaxDepth(nodes);

    // 2. Initial placement (DFS)
    double currentGlobalY = 0.0;
    for (final rootNode in rootNodes) {
      _positionNodeDFS(rootNode.id, 0, currentGlobalY, nodes, spaceX, spaceY);
      currentGlobalY = _getMaxY(rootNode.id, nodes) + spaceY * 5;
    }

    // 3. Adjust parent positions (bottom-up)
    for (int i = maxDepth; i >= 0; i--) {
      for (final node in nodes.values.where(
        (node) => _getDepth(node.id, nodes) == i,
      )) {
        if (node.childrenIds.isNotEmpty) {
          final reversedChildrenIds = node.childrenIds.reversed.toList();
          double topMostChildY = nodes[reversedChildrenIds.first]!.y;
          double bottomMostChildY = nodes[reversedChildrenIds.last]!.y;
          node.y = (topMostChildY + bottomMostChildY) / 2;
        }
      }
    }
  }

  // calculateConnectionsの実装は、UIで直接処理している接続線をここに移動することも可能です。
  // 今回はUIに残していますが、もし接続線のロジックも完全に分離したい場合はここに実装します。
  @override
  List<Connection> calculateConnections(Map<int, Node> nodes) {
    // 現在のコードでは、接続線はUI側で描画ロジックと密接に結びついています。
    // そのため、ここでは空のリストを返します。
    // もし接続線の計算もロジックに含めたい場合は、ここに実装を追加します。
    return [];
  }

  double _positionNodeDFS(int nodeId, int depth, double currentY,
      Map<int, Node> nodes, double spaceX, double spaceY) {
    final node = nodes[nodeId]!;
    node.x = -depth * spaceX; // 左側に配置

    if (node.childrenIds.isEmpty) {
      node.y = currentY;
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
      node.y = currentY; // Temporary, will be adjusted later
      return nextY;
    }
  }

  double _getMaxY(int nodeId, Map<int, Node> nodes) {
    final node = nodes[nodeId]!;
    double maxY = node.y;
    for (final childId in node.childrenIds) {
      maxY = math.max(maxY, _getMaxY(childId, nodes));
    }
    return maxY;
  }

  int _calculateMaxDepth(Map<int, Node> nodes) {
    int maxDepth = 0;
    for (final node in nodes.values) {
      maxDepth = math.max(maxDepth, _getDepth(node.id, nodes));
    }
    return maxDepth;
  }

  int _getDepth(int? nodeId, Map<int, Node> nodes) {
    int depth = 0;
    int? currentId = nodeId;
    while (currentId != null) {
      final node = nodes[currentId];
      if (node == null) break;
      currentId = node.parentId;
      depth++;
    }
    return depth - 1; // Subtract 1 to start depth at 0 for the root node
  }
}
