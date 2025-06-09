import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_client/common/widget/node_widget.dart';
import 'package:flutter_client/common/widget/painter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../model/node.dart';

class RoadmapWidget extends HookWidget {
  final Map<int, Node> nodes;
  final int? initialSelectedNodeId;
  final void Function(int nodeId)? onNodeTap;
  final int offsetY = 60;
  final int offsetX = 25;

  const RoadmapWidget({
    super.key,
    required this.nodes,
    this.initialSelectedNodeId,
    this.onNodeTap,
  });

  // Connection helper functions (adapted for Node)
  Node? findLeftAncle(Node node, Map<int, Node> nodes) {
    Node? currentParent = node.parentId != null ? nodes[node.parentId] : null;
    while (currentParent != null) {
      final grandParent =
          currentParent.parentId != null ? nodes[currentParent.parentId] : null;
      if (grandParent == null) break;
      final ancles = grandParent.childrenIds;
      final ancleIndex = ancles.indexOf(currentParent.id);
      if (ancleIndex > 0) {
        final leftAncleId = ancles[ancleIndex - 1];
        return nodes[leftAncleId];
      }
      currentParent = grandParent;
    }
    return null;
  }

  Node? findRightAunt(Node node, Map<int, Node> nodes) {
    Node? currentParent = node.parentId != null ? nodes[node.parentId] : null;
    while (currentParent != null) {
      final grandParent =
          currentParent.parentId != null ? nodes[currentParent.parentId] : null;
      if (grandParent == null) break;
      final aunts = grandParent.childrenIds;
      final auntIndex = aunts.indexOf(currentParent.id);
      if (auntIndex >= 0 && auntIndex < aunts.length - 1) {
        final rightAuntId = aunts[auntIndex + 1];
        return nodes[rightAuntId];
      }
      currentParent = grandParent;
    }
    return null;
  }

  Node? findRightMostDescendant(Node node, Map<int, Node> nodes) {
    Node? currentNode = node;
    while (currentNode != null && currentNode.childrenIds.isNotEmpty) {
      final rightMostChildId = currentNode.childrenIds.last;
      currentNode = nodes[rightMostChildId];
    }
    return currentNode;
  }

  Node? findLeftMostDescendant(Node node, Map<int, Node> nodes) {
    Node? currentNode = node;
    while (currentNode != null && currentNode.childrenIds.isNotEmpty) {
      final leftMostChildId = currentNode.childrenIds.first;
      currentNode = nodes[leftMostChildId];
    }
    return currentNode;
  }

  @override
  Widget build(BuildContext context) {
    // Hooksを使って選択されたノードのIDを管理
    final selectedNodeId = useState<int?>(initialSelectedNodeId);

    if (nodes.isEmpty) {
      return const Center(child: Text('No nodes to display'));
    }

    double minY = double.infinity;
    double maxY = 0;
    double minX = double.infinity;
    double maxX = 0;
    for (final node in nodes.values) {
      minX = math.min(minX, node.x);
      maxX = math.max(maxX, node.x);
      minY = math.min(minY, node.y);
      maxY = math.max(maxY, node.y);
    }
    // シフト量
    final yShift = minY < 0 ? -minY + 30 : 30;
    final xShift = minX < 0 ? -minX + 30 : 30;
    maxX += 100;
    maxY += 250;

    // ノードタップハンドラー
    void handleNodeTap(int nodeId) {
      selectedNodeId.value = nodeId;
      onNodeTap?.call(nodeId);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: maxY + yShift,
            height: maxX + xShift,
            child: Stack(
              children: [
                // Sibling connections
                ...nodes.values.map((node) {
                  if (node.parentId == null) return const SizedBox.shrink();
                  final parent = nodes[node.parentId];
                  if (parent == null) return const SizedBox.shrink();
                  // Get the left sibling node
                  final siblings = parent.childrenIds;
                  final nodeIndex = siblings.indexOf(node.id);
                  if (nodeIndex <= 0) {
                    return const SizedBox.shrink(); // No left sibling
                  }

                  final leftSiblingId = siblings[nodeIndex - 1];
                  final leftSibling = nodes[leftSiblingId];
                  if (leftSibling == null) return const SizedBox.shrink();
                  // Draw connection to left sibling
                  return CustomPaint(
                    painter: ConnectionPainterSibling(
                      start: Offset(
                          leftSibling.y + offsetY + yShift,
                          leftSibling.x + offsetX + xShift),
                      end: Offset(
                          node.y + offsetY + yShift, node.x + offsetX + xShift),
                      color: Colors.red,
                    ),
                  );
                }),
                // Draw Ancle connections
                ...nodes.values.map((node) {
                  if (node.parentId == null) return const SizedBox.shrink();
                  final parent = nodes[node.parentId];
                  if (parent == null) return const SizedBox.shrink();
                  final leftAncle = findLeftAncle(node, nodes);
                  if (leftAncle == null) return const SizedBox.shrink();
                  final siblings = parent.childrenIds;
                  final nodeIndex = siblings.indexOf(node.id);
                  if (nodeIndex > 0) return const SizedBox.shrink();
                  final leftChild = findLeftMostDescendant(node, nodes);
                  return CustomPaint(
                    painter: ConnectionPainterToChild(
                      start: Offset(
                        leftAncle.y + offsetY,
                        leftAncle.x + offsetX + xShift,
                      ),
                      end: Offset(
                          node.y + offsetY + yShift, node.x + offsetX + xShift),
                      curveStart: leftChild != null
                          ? Offset(leftChild.y + offsetY + yShift,
                              leftChild.x + offsetX + xShift)
                          : Offset(node.y + offsetY + yShift,
                              node.x + offsetX + xShift),
                      color: Colors.green,
                    ),
                  );
                }),
                // Draw aunt connections
                ...nodes.values.map((node) {
                  if (node.parentId == null) return const SizedBox.shrink();
                  final parent = nodes[node.parentId];
                  if (parent == null) return const SizedBox.shrink();
                  final rightAunt = findRightAunt(node, nodes);
                  if (rightAunt == null) return const SizedBox.shrink();
                  final siblings = parent.childrenIds;
                  final nodeIndex = siblings.indexOf(node.id);
                  if (nodeIndex < siblings.length - 1) {
                    return const SizedBox.shrink();
                  }
                  final rightChild = findRightMostDescendant(node, nodes);
                  return CustomPaint(
                    painter: ConnectionPainterAunt(
                      start:
                          Offset(
                          node.y + offsetY + yShift, node.x + offsetX + xShift),
                      end: Offset(rightAunt.y + offsetY + yShift,
                          rightAunt.x + offsetX + xShift),
                      curveStart: rightChild != null
                          ? Offset(
                              rightChild.y + offsetY + yShift,
                              rightChild.x + offsetX + xShift)
                          : Offset(node.y + offsetY + yShift,
                              node.x + offsetX + xShift),
                      color: Colors.blue,
                    ),
                  );
                }),
                // Node widgets with selection border
                ...nodes.values.map((node) {
                  final isSelected = selectedNodeId.value == node.id;
                  return NodeWidget(
                    node: node,
                    x: node.x + xShift,
                    y: node.y + yShift,
                    isSelected: isSelected,
                    onTap: () => handleNodeTap(node.id),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
