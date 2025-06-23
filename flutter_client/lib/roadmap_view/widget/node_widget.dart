
import 'package:flutter/material.dart';

import '../../common/model/node.dart';

class NodeWidget extends StatelessWidget {
final Node node;
  final double x;
  final double y;
  final double width;
  final double height;
  final bool isSelected;
  final void Function()? onTap;

// 基調色
  static const Color primaryColor = Color(0xFF4387F4);
  static const Color secondaryColor = Color(0xFF895AF6);
  static const Color textColor = Colors.white;
  static const Color successColor = Color(0xFF1ba14c);

const NodeWidget({
    super.key,
    required this.node,
    required this.x,
    required this.y,
this.width = 160, // 少し幅を広めに
    this.height = 60, // 少し高めに
    this.isSelected = false,
    this.onTap,
  });

@override
  Widget build(BuildContext context) {
Color nodeBackgroundColor;
    Color? progressColor;
    String label;
double borderWidth = 2.0;

    final progress = node.progressRate / 100;
    final borderColor =
        Color.lerp(Colors.grey.shade400, primaryColor, progress)!;
    borderWidth = 1.0 + progress * 1.0; // 進捗に応じて太さを調整

switch (node.nodeType) {
      case NodeType.start:
        nodeBackgroundColor = primaryColor;
        label = 'Start';
        break;
      case NodeType.goal:
        nodeBackgroundColor = secondaryColor;
        label = 'Goal';
        break;
      case NodeType.root:
        nodeBackgroundColor = primaryColor.withOpacity(0.9);
        label = 'Root';
        break;
      case NodeType.normal:
      default:
        nodeBackgroundColor = Colors.grey.shade600;
        progressColor = primaryColor.withOpacity(0.2); // 薄いプログレスバーの色
        label = node.title;
        break;
    }

return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: nodeBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? secondaryColor
                  : borderColor, // 選択時はsecondaryColor
              width: isSelected ? 3 : borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
              if (isSelected)
                BoxShadow(
                  color: secondaryColor.withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Stack(
            children: [
              // 進捗バー（normalノードの場合）
              if (node.nodeType == NodeType.normal && progressColor != null)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.7),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (node.nodeType == NodeType.normal)
                        Text(
                          '${node.progressRate}%',
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );


}
}
