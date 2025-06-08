// lib/default_tree_layout_algorithm.dart (新規ファイル)
import 'dart:math' as math;

import 'package:flutter_client/common/interface/tree_layout_gorithm.dart';
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
    double currentGlobalX = 0.0;
    for (final rootNode in rootNodes) {
      _positionNodeDFS(rootNode.id, 0, currentGlobalX, nodes, spaceX, spaceY);
      currentGlobalX = _getMaxX(rootNode.id, nodes) + spaceX * 5;
    }

    // 3. Adjust parent positions (bottom-up)
    for (int i = maxDepth; i >= 0; i--) {
      for (final node in nodes.values.where(
        (node) => _getDepth(node.id, nodes) == i,
      )) {
        if (node.childrenIds.isNotEmpty) {
          double leftMostChildX = nodes[node.childrenIds.first]!.x;
          double rightMostChildX = nodes[node.childrenIds.last]!.x;
          node.x = (leftMostChildX + rightMostChildX) / 2;
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

  double _positionNodeDFS(int nodeId, int depth, double currentX,
      Map<int, Node> nodes, double spaceX, double spaceY) {
    final node = nodes[nodeId]!;
    node.y = depth * spaceY;

    if (node.childrenIds.isEmpty) {
      node.x = currentX;
      return currentX + spaceX;
    } else {
      double nextX = currentX;
      for (final childId in node.childrenIds) {
        nextX = _positionNodeDFS(
          childId,
          depth + 1,
          nextX,
          nodes,
          spaceX,
          spaceY,
        );
      }
      node.x = currentX; // Temporary, will be adjusted later
      return nextX;
    }
  }

  double _getMaxX(int nodeId, Map<int, Node> nodes) {
    final node = nodes[nodeId]!;
    double maxX = node.x;
    for (final childId in node.childrenIds) {
      maxX = math.max(maxX, _getMaxX(childId, nodes));
    }
    return maxX;
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
