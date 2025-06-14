import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/common/model/road_map.dart';

abstract class RoadmapRepositoryInterface {
  RoadmapRepositoryInterface();
  Future<Map<int, Node>> getAllNodes(String userId, String mapId);
  Future<Map<int, Node>> exploreNodes({
    required List<Node> selectedNodeList,
    required String mapId,
    required String objective,
    required String profile,
  });
  Future<Map<int, Node>> adjustNodes(RoadMap roadMap);
}
