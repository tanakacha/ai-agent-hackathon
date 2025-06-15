import 'package:flutter_client/common/interface/roadmap_repository_repository.dart';
import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/common/model/road_map.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'roadmap_repository.g.dart';

@riverpod
RoadmapRepositoryInterface roadmapRepository(RoadmapRepositoryRef ref) =>
    _RoadmapRepositoryRepository();

class _RoadmapRepositoryRepository extends RoadmapRepositoryInterface {
  _RoadmapRepositoryRepository();

  @override
  Future<Map<int, Node>> getAllNodes(String userId, String mapId) async {
    final now = DateTime.now();
    return {
      1: Node(
        id: 1,
        parentId: null,
        childrenIds: [2, 3],
        nodeType: NodeType.root,
        title: 'Mock Node 1',
        description: 'This is a mock node',
        duration: 60,
        progressRate: 0,
        x: 100,
        y: 100,
        dueAt: now.add(const Duration(days: 7)),
        createdAt: now,
        updatedAt: now,
      ),
    };
  }

  @override
  Future<Map<int, Node>> exploreNodes({
    required List<Node> selectedNodeList,
    required String mapId,
    required String objective,
    required String profile,
  }) async {
    final now = DateTime.now();
    return {
      3: Node(
        id: 3,
        parentId: 1,
        childrenIds: [],
        nodeType: NodeType.normal,
        title: 'Explored Node',
        description: 'This is an explored node based on objective: $objective',
        duration: 45,
        progressRate: 0,
        x: 300,
        y: 300,
        dueAt: now.add(const Duration(days: 10)),
        createdAt: now,
        updatedAt: now,
      ),
    };
  }

  @override
  Future<Map<int, Node>> adjustNodes(RoadMap roadMap) async {
    final nodes = roadMap.nodes;
    final adjustedNodes = <int, Node>{};
    final now = DateTime.now();

    for (final node in nodes) {
      adjustedNodes[node.id] = Node(
        id: node.id,
        parentId: node.parentId,
        childrenIds: node.childrenIds,
        nodeType: node.nodeType,
        title: node.title,
        description: node.description,
        duration: node.duration,
        progressRate: node.progressRate,
        x: node.x + 10, // Slight adjustment
        y: node.y + 10, // Slight adjustment
        dueAt: node.dueAt,
        finishedAt: node.finishedAt,
        createdAt: node.createdAt,
        updatedAt: now,
      );
    }

    return adjustedNodes;
  }
}
