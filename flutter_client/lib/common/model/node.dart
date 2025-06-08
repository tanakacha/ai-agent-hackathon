enum NodeType { start, goal, normal, root }

class Node {
  int id;
  int? parentId;
  List<int> childrenIds;
  NodeType nodeType;
  String title;
  String description;
  int duration;
  int progressRate;
  double x;
  double y;
  DateTime dueAt;
  DateTime? finishedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Node({
    required this.id,
    required this.parentId,
    required this.childrenIds,
    required this.nodeType,
    required this.title,
    required this.description,
    required this.duration,
    required this.progressRate,
    this.x = 0,
    this.y = 0,
    required this.dueAt,
    this.finishedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
