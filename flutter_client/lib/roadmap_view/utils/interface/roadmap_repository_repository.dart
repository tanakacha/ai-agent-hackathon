import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/common/model/road_map.dart';

abstract class RoadmapRepositoryInterface {
  RoadmapRepositoryInterface();
  Future<Map<String, Node>> getAllNodes(String userId, String mapId);
  Future<Map<String, Node>> exploreNodes({
    required List<Node> selectedNodeList,
    required String mapId,
    required String objective,
    required String profile,
  });
  Future<Map<String, Node>> adjustNodes(RoadMap roadMap);
}
