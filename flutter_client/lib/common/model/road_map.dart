import 'package:flutter_client/common/model/node.dart';

class RoadMap {
  String id;
  String title;
  String objective;
  String profile;
  DateTime deadline;
  DateTime createdAt;
  DateTime updatedAt;
  List<Node> nodes;

  RoadMap({
    required this.id,
    required this.title,
    required this.objective,
    required this.profile,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.nodes,
  });

  factory RoadMap.fromJson(Map<String, dynamic> json) {
    return RoadMap(
      id: json['id'] as String,
      title: json['title'] as String,
      objective: json['objective'] as String,
      profile: json['profile'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      nodes: [],
    );
  }

  void setNodes(List<Node> newNodes) {
    nodes = newNodes;
  }

  @override
  String toString() {
    return 'RoadMap(id: $id, title: $title, nodes count: ${nodes.length})';
  }

}
