// lib/tree_view_page.dart (新規ファイル)
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_client/common/widget/node_widget.dart';
import 'package:flutter_client/common/widget/painter.dart';

import '../model/node.dart';

class RoadmapWidget extends StatelessWidget {
  final Map<int, Node> nodes;
  final int? selectedNodeId;
  final void Function(int nodeId)? onNodeTap;
  final int offsetY = 60;
  final int offsetX = 25;

  const RoadmapWidget({
    super.key,
    required this.nodes,
    this.selectedNodeId,
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
    if (nodes.isEmpty) {
      return const Center(child: Text('No nodes to display'));
    }
    double maxX = 0;
    double maxY = 0;
    for (final node in nodes.values) {
      maxX = math.max(maxX, node.x);
      maxY = math.max(maxY, node.y);
    }
    maxX += 100;
    maxY += 250;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: maxY,
            height: maxX,
            child: Stack(
              children: [
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
                          leftSibling.y + offsetY, leftSibling.x + offsetX),
                      end: Offset(node.y + offsetY, node.x + offsetX),
                      color: Colors.grey,
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
                    painter: ConnectionPainterAncle(
                      start: Offset(
                        leftAncle.y + offsetY,
                        leftAncle.x + offsetX,
                      ),
                      end: Offset(node.y + offsetY, node.x + offsetX),
                      curveEnd: leftChild != null
                          ? Offset(leftChild.y + offsetY, leftChild.x + offsetX)
                          : Offset(node.y + offsetY, node.x + offsetX),
                      color: Colors.grey,
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
                          Offset(rightAunt.y + offsetY, rightAunt.x + offsetX),
                      end: Offset(node.y + offsetY, node.x + offsetX),
                      curveStart: rightChild != null
                          ? Offset(
                              rightChild.y + offsetY, rightChild.x + offsetX)
                          : Offset(node.y + offsetY, node.x + offsetX),
                      color: Colors.grey,
                    ),
                  );
                }),
                ...nodes.values.map((node) {
                  final isSelected = selectedNodeId == node.id;
                  return NodeWidget(
                    node: node,
                    x: node.x,
                    y: node.y,
                    isSelected: isSelected,
                    onTap: onNodeTap != null ? () => onNodeTap!(node.id) : null,
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
