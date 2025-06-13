// lib/tree_view_page.dart (新規ファイル)
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_client/common/widget/node_widget.dart';
import 'package:flutter_client/common/widget/painter.dart';

import '../model/node.dart';

class RoadmapWidget extends StatefulWidget {
  static const double _nodeWidth = 100.0;
  static const double _nodeHeight = 50.0;
  static const double _padding = 30.0;
  static const double _nodeCenterY = _nodeHeight / 2;
  static const double _horizontalOffset = 500.0;
  static const double _nodeOffsetX = -_nodeWidth / 2;
  static const double _minXPadding = 50.0;
  static const double _maxYPadding = 100;

  final Map<int, Node> nodes;
  final int? selectedNodeId;
  final void Function(int nodeId)? onNodeTap;

  const RoadmapWidget({
    super.key,
    required this.nodes,
    this.selectedNodeId,
    this.onNodeTap,
  });

  @override
  State<RoadmapWidget> createState() => RoadmapWidgetState();
}

class RoadmapWidgetState extends State<RoadmapWidget> {
  final horizontalController = ScrollController();
  final verticalController = ScrollController();

  void focusNode(int nodeId) {
    final node = widget.nodes[nodeId];
    if (node == null) return;

    // Calculate the target position
    final targetX = node.x + 350 + RoadmapWidget._nodeOffsetX;
    final targetY = node.y - 200;
    print('$targetX, $targetY');
    // Animate to the target position
    horizontalController.animateTo(
      targetX,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    verticalController.animateTo(
      targetY,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

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
    if (widget.nodes.isEmpty) {
      return const Center(child: Text('No nodes to display'));
    }
    double minX = 0;
    double maxY = 0;
    for (final node in widget.nodes.values) {
      minX = math.min(minX, node.x);
      maxY = math.max(maxY, node.y);
    }
    minX -= RoadmapWidget._minXPadding; // Add some padding
    maxY += RoadmapWidget._maxYPadding;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: horizontalController,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: verticalController,
        child: Padding(
          padding: const EdgeInsets.all(RoadmapWidget._padding),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: SizedBox(
              width: -minX + RoadmapWidget._horizontalOffset,
              height: maxY,
              child: Stack(
                children: [
                  ...widget.nodes.values.map((node) {
                    if (node.parentId == null) return const SizedBox.shrink();
                    final parent = widget.nodes[node.parentId];
                    if (parent == null) return const SizedBox.shrink();
                    // Get the left sibling node
                    final siblings = parent.childrenIds;
                    final nodeIndex = siblings.indexOf(node.id);
                    if (nodeIndex <= 0) {
                      return const SizedBox.shrink(); // No left sibling
                    }

                    final leftSiblingId = siblings[nodeIndex - 1];
                    final leftSibling = widget.nodes[leftSiblingId];
                    if (leftSibling == null) return const SizedBox.shrink();
                    // Draw connection to left sibling
                    return CustomPaint(
                      painter: ConnectionPainterSibling(
                        start: Offset(
                            leftSibling.x + RoadmapWidget._horizontalOffset,
                            leftSibling.y + RoadmapWidget._nodeCenterY),
                        end: Offset(node.x + RoadmapWidget._horizontalOffset,
                            node.y + RoadmapWidget._nodeCenterY),
                        color: Colors.green,
                      ),
                    );
                  }),
                  // Draw Ancle connections
                  ...widget.nodes.values.map((node) {
                    if (node.parentId == null) return const SizedBox.shrink();
                    final parent = widget.nodes[node.parentId];
                    if (parent == null) return const SizedBox.shrink();
                    final leftAncle = findLeftAncle(node, widget.nodes);
                    if (leftAncle == null) return const SizedBox.shrink();
                    final siblings = parent.childrenIds;
                    final nodeIndex = siblings.indexOf(node.id);
                    if (nodeIndex > 0) return const SizedBox.shrink();
                    final leftChild =
                        findLeftMostDescendant(node, widget.nodes);
                    return CustomPaint(
                      painter: ConnectionPainterAncle(
                        start: Offset(
                            leftAncle.x + RoadmapWidget._horizontalOffset,
                            leftAncle.y + RoadmapWidget._nodeCenterY),
                        end: Offset(node.x + RoadmapWidget._horizontalOffset,
                            node.y + RoadmapWidget._nodeCenterY),
                        curveEnd: leftChild != null
                            ? Offset(
                                leftChild.x + RoadmapWidget._horizontalOffset,
                                leftChild.y + RoadmapWidget._nodeCenterY)
                            : Offset(node.x + RoadmapWidget._horizontalOffset,
                                node.y + RoadmapWidget._nodeCenterY),
                        midpoint: Offset(
                          (leftAncle.x + node.x) / 2 +
                              RoadmapWidget._horizontalOffset,
                          (leftAncle.y + node.y) / 2 +
                              RoadmapWidget._nodeCenterY,
                        ),
                        color: Colors.blue,
                      ),
                    );
                  }),
                  // Draw parent-child connections
                  ...widget.nodes.values.map((node) {
                    if (node.parentId == null) return const SizedBox.shrink();
                    final parent = widget.nodes[node.parentId];
                    if (parent == null) return const SizedBox.shrink();
                    final rightAunt = findRightAunt(node, widget.nodes);
                    if (rightAunt == null) return const SizedBox.shrink();
                    final siblings = parent.childrenIds;
                    final nodeIndex = siblings.indexOf(node.id);
                    if (nodeIndex < siblings.length - 1) {
                      return const SizedBox.shrink();
                    }
                    final rightChild =
                        findRightMostDescendant(node, widget.nodes);
                    return CustomPaint(
                      painter: ConnectionPainterAunt(
                        start: Offset(node.x + RoadmapWidget._horizontalOffset,
                            node.y + RoadmapWidget._nodeCenterY),
                        end: Offset(
                            rightAunt.x + RoadmapWidget._horizontalOffset,
                            rightAunt.y + RoadmapWidget._nodeCenterY),
                        curveStart: rightChild != null
                            ? Offset(
                                rightChild.x + RoadmapWidget._horizontalOffset,
                                rightChild.y + RoadmapWidget._nodeCenterY)
                            : Offset(node.x + RoadmapWidget._horizontalOffset,
                                node.y + RoadmapWidget._nodeCenterY),
                        midpoint: Offset(
                          (rightAunt.x + node.x) / 2 +
                              RoadmapWidget._horizontalOffset,
                          (rightAunt.y + node.y) / 2 +
                              RoadmapWidget._nodeCenterY,
                        ),
                        color: Colors.red,
                      ),
                    );
                  }),
                  ...widget.nodes.values.map((node) {
                    final isSelected = widget.selectedNodeId == node.id;
                    return NodeWidget(
                      node: node,
                      x: node.x +
                          RoadmapWidget._horizontalOffset +
                          RoadmapWidget._nodeOffsetX,
                      y: node.y,
                      width: RoadmapWidget._nodeWidth,
                      height: RoadmapWidget._nodeHeight,
                      isSelected: isSelected,
                      onTap: widget.onNodeTap != null
                          ? () => widget.onNodeTap!(node.id)
                          : null,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
