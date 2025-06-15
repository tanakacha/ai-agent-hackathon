// lib/tree_view_page.dart (更新版)
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_client/common/widget/node_widget.dart';
import 'package:flutter_client/common/widget/painter.dart';

import '../model/node.dart';

class RoadmapWidget extends StatefulWidget {
  static const double _nodeWidth = 100.0;
  static const double _nodeHeight = 50.0;
  static const double _roadmapPadding = 30.0;
  static const double _nodeSpacingX = 50.0; // Horizontal spacing between nodes
  static const double _nodeSpacingY = 20.0; // Vertical spacing between nodes
  static const double _nodeCenterY = _nodeHeight / 2;
  static const double _horizontalOffset = 1500.0;
  static const double _nodeOffsetX = -_nodeWidth / 2;
  static const double _minXPadding = 50.0;
  static const double _maxYPadding = 100;
  static const double _curveSpacing = 50.0; // Spacing for curved connections

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

    final targetX =
        _getAdjustedNodeX(node) - 150 + RoadmapWidget._horizontalOffset;
    final targetY = _getAdjustedNodeY(node) - 150;

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

  double _getAdjustedNodeX(Node node) {
    return node.x *
        (1 + RoadmapWidget._nodeSpacingX / RoadmapWidget._nodeWidth);
  }

  double _getAdjustedNodeY(Node node) {
    return node.y *
        (1 + RoadmapWidget._nodeSpacingY / RoadmapWidget._nodeHeight);
  }

  Offset _getAdjustedNodePosition(Node node) {
    return Offset(
      _getAdjustedNodeX(node) + RoadmapWidget._horizontalOffset,
      _getAdjustedNodeY(node) + RoadmapWidget._nodeCenterY,
    );
  }

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

    // Calculate bounds with spacing applied
    double minX = 0;
    double maxY = 0;
    for (final node in widget.nodes.values) {
      final adjustedX = _getAdjustedNodeX(node);
      final adjustedY = _getAdjustedNodeY(node);
      minX = math.min(minX, adjustedX);
      maxY = math.max(maxY, adjustedY);
    }
    minX += RoadmapWidget._minXPadding; // Add some padding
    maxY += RoadmapWidget._maxYPadding;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: horizontalController,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: verticalController,
        child: Padding(
          padding: const EdgeInsets.all(RoadmapWidget._roadmapPadding),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: SizedBox(
              width: -minX + RoadmapWidget._horizontalOffset,
              height: 2000,
              child: Stack(
                children: [
                  // Draw sibling connections
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

                    // Draw connection to left sibling with spacing applied
                    return CustomPaint(
                      painter: ConnectionPainterSibling(
                        start: _getAdjustedNodePosition(leftSibling),
                        end: _getAdjustedNodePosition(node),
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

                    final leftAnclePos = _getAdjustedNodePosition(leftAncle);
                    final nodePos = _getAdjustedNodePosition(node);
                    final leftChildPos = leftChild != null
                        ? _getAdjustedNodePosition(leftChild)
                        : nodePos;

                    return CustomPaint(
                      painter: ConnectionPainterAncle(
                        start: leftAnclePos,
                        end: nodePos,
                        curveEnd: leftChildPos,
                        midpoint:
                        Offset(
                          leftAnclePos.dx - RoadmapWidget._curveSpacing,
                          leftAnclePos.dy - RoadmapWidget._curveSpacing,
                        ),
                        color: Colors.blue,
                      ),
                    );
                  }),

                  // Draw Aunt connections
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

                    final nodePos = _getAdjustedNodePosition(node);
                    final rightAuntPos = _getAdjustedNodePosition(rightAunt);
                    final rightChildPos = rightChild != null
                        ? _getAdjustedNodePosition(rightChild)
                        : nodePos;

                    return CustomPaint(
                      painter: ConnectionPainterAunt(
                        start: nodePos,
                        end: rightAuntPos,
                        curveStart: rightChildPos,
                        midpoint:
                        Offset(
                          rightAuntPos.dx + RoadmapWidget._curveSpacing,
                          rightAuntPos.dy + RoadmapWidget._curveSpacing,
                        ),
                        color: Colors.red,
                      ),
                    );
                  }),

                  // Draw nodes with spacing applied
                  ...widget.nodes.values.map((node) {
                    final isSelected = widget.selectedNodeId == node.id;
                    return NodeWidget(
                      node: node,
                      x: _getAdjustedNodeX(node) +
                          RoadmapWidget._horizontalOffset +
                          RoadmapWidget._nodeOffsetX,
                      y: _getAdjustedNodeY(node),
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
