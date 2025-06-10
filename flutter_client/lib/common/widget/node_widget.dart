import 'package:flutter/material.dart';

import '../model/node.dart';

class NodeWidget extends StatelessWidget {
  final Node node;
  final double x;
  final double y;
  final double width;
  final double height;
  final bool isSelected;
  final void Function()? onTap;

  const NodeWidget({
    super.key,
    required this.node,
    required this.x,
    required this.y,
    this.width = 120,
    this.height = 50,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    BoxShape shape = BoxShape.circle;

    switch (node.nodeType) {
      case NodeType.start:
        color = const Color.fromARGB(10, 0, 255, 0);
        label = 'Start';
        shape = BoxShape.rectangle;
        break;
      case NodeType.goal:
        color = Colors.red;
        label = 'Goal';
        shape = BoxShape.rectangle;
        break;
      case NodeType.root:
        color = Colors.blue;
        label = 'Root';
        shape = BoxShape.rectangle;
        break;
      case NodeType.normal:
      default:
        color = const Color.fromARGB(10, 0, 0, 0);
        label = node.title;
        shape = BoxShape.circle;
        break;
    }

    return Positioned(
      left: y,
      top: x,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            shape: shape,
            border:
                isSelected ? Border.all(color: Colors.yellow, width: 3) : null,
            borderRadius:
                shape == BoxShape.rectangle ? BorderRadius.circular(10) : null,
          ),
          child: Center(
            child: Text(
              "y$y:x$x",
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
