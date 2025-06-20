import 'package:flutter_client/common/model/node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/road_map.freezed.dart';

@freezed
class RoadMap with _$RoadMap {
  const factory RoadMap({
    required String id,
    required String title,
    required String objective,
    required String profile,
    required DateTime deadline,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Map<String, Node> nodes,
  }) = _RoadMap;

  factory RoadMap.fromJson(Map<String, dynamic> json) =>
      _$RoadMapFromJson(json);

  RoadMap setNodes(Map<String, Node> newNodes) {
    return copyWith(nodes: newNodes);
  }
}

Map<String, Node> listToNodeMap(List<Node> nodeList) {
  return {for (var node in nodeList) node.id: node};
}
