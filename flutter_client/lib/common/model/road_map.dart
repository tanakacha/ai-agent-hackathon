import 'package:flutter_client/common/model/node.dart';

class RoadMap {
  int id;
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
}
