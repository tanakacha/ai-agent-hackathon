import 'package:flutter/material.dart';
import 'package:flutter_client/common/model/node.dart';

/// ツリーノードの配置アルゴリズムを定義するインターフェース
abstract class TreeLayoutAlgorithm {
  /// ノードの位置を計算し、更新します。
  /// [nodes] はツリー内の全ノードのマップです。
  /// [rootNodes] はツリーのルートノードのリストです（複数のツリーをサポートする場合）。
  /// [spaceX] はノード間の水平方向のスペースです。
  /// [spaceY] はノード間の垂直方向のスペースです。
  void calculatePositions({
    required Map<String, Node> nodes,
    required List<Node> rootNodes,
    required double spaceX,
    required double spaceY,
  });
}

/// 接続線の情報を保持するクラス
class Connection {
  final Offset start;
  final Offset end;
  final Offset? curveStart;
  final Offset? curveEnd;
  final ConnectionType type;

  Connection({
    required this.start,
    required this.end,
    this.curveStart,
    this.curveEnd,
    required this.type,
  });
}

enum ConnectionType {
  sibling,
  ancle,
  aunt,
  parentChild, // 親子間の接続を追加する場合
}
