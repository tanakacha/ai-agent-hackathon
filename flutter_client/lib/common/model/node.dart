import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/node.freezed.dart';

enum NodeType {
  @JsonValue('Start')
  start,
  @JsonValue('Goal')
  goal,
  @JsonValue('Task')
  normal,
  @JsonValue('Root')
  root
}

@freezed
class Node with _$Node {
  const Node._();
  const factory Node({
    required String id,
    String? parentId,
    @Default([]) List<String> childrenIds,
    required NodeType nodeType,
    required String title,
    required String description,
    required int duration,
    required int progressRate,
    @Default(0.0) double x,
    @Default(0.0) double y,
    required DateTime dueAt,
    DateTime? finishedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? mapId,
  }) = _Node;

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'] as String,
      parentId: json['parent_id'] as String?,
      childrenIds:
          (json['children_ids'] as List<dynamic>?)?.cast<String>() ?? [],
      nodeType: _parseNodeType(json['node_type'] as String?),
      title: json['title'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int,
      progressRate: json['progress_rate'] as int,
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      dueAt: DateTime.parse(json['due_at'] as String),
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      mapId: json['map_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'children_ids': childrenIds,
      'node_type': _nodeTypeToString(nodeType),
      'title': title,
      'description': description,
      'duration': duration,
      'progress_rate': progressRate,
      'x': x,
      'y': y,
      'due_at': dueAt.toIso8601String(),
      'finished_at': finishedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'map_id': mapId,
    };
  }

  static NodeType _parseNodeType(String? type) {
    switch (type) {
      case 'Start':
        return NodeType.start;
      case 'Goal':
        return NodeType.goal;
      case 'Task':
        return NodeType.normal;
      case 'Root':
        return NodeType.root;
      default:
        return NodeType.normal;
    }
  }

  static String _nodeTypeToString(NodeType type) {
    switch (type) {
      case NodeType.start:
        return 'Start';
      case NodeType.goal:
        return 'Goal';
      case NodeType.normal:
        return 'Task';
      case NodeType.root:
        return 'Root';
    }
  }
}
