enum NodeType { start, goal, normal, root }

extension NodeTypeExtension on NodeType {
  static NodeType fromString(String value) {
    return NodeType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => NodeType.normal, // デフォルト値
    );
  }
}

class Node {
  String id;
  String? parentId;
  List<String> childrenIds;
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

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'],
      parentId: json['parent_id'],
      childrenIds: List<String>.from(json['children_ids']),
      nodeType: NodeTypeExtension.fromString(json['node_type']),
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      progressRate: json['progress_rate'],
      dueAt: DateTime.parse(json['due_at']),
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  String toString() {
    return 'Node(id: $id, parentId: $parentId, childrenIds: $childrenIds, '
        'type: $nodeType, title: $title, x: $x, y: $y)';
  }
}
