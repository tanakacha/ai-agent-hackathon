import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/common/model/road_map.dart';
import 'package:flutter_client/roadmap_view/utils/interface/roadmap_repository.dart';
import 'package:flutter_client/roadmap_view/utils/interface/roadmap_repository_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'roadmap_manager.g.dart';

abstract class RoadmapManagerInterface {
  RoadmapManagerInterface();
  Future<Map<String, Node>> getAllNodes(String userId, String mapId);
  Future<Map<String, Node>> exploreNodes({
    required List<Node> selectedNodeList,
    required String mapId,
    required String objective,
    required String profile,
  });
  Future<Map<String, Node>> adjustNodes(RoadMap roadMap);
}

@riverpod
RoadmapManagerInterface roadmapManager(RoadmapManagerRef ref) =>
    _RoadmapManager(
      roadmapRepository: ref.watch(roadmapRepositoryProvider),
    );

class _RoadmapManager extends RoadmapManagerInterface {
  _RoadmapManager({
    required this.roadmapRepository,
  });

  final RoadmapRepositoryInterface roadmapRepository;

  @override
  Future<Map<String, Node>> getAllNodes(String userId, String mapId) async =>
      roadmapRepository.getAllNodes(userId, mapId);

  @override
  Future<Map<String, Node>> exploreNodes({
    required List<Node> selectedNodeList,
    required String mapId,
    required String objective,
    required String profile,
  }) async =>
      roadmapRepository.exploreNodes(
        selectedNodeList: selectedNodeList,
        mapId: mapId,
        objective: objective,
        profile: profile,
      );

  @override
  Future<Map<String, Node>> adjustNodes(RoadMap roadMap) async =>
      roadmapRepository.adjustNodes(roadMap);
}
