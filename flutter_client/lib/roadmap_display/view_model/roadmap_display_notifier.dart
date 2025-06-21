import 'package:flutter_client/common/model/road_map.dart';
import 'package:flutter_client/providers/nodes_provider.dart';
import 'package:flutter_client/services/roadmap_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final roadmapDisplayNotifierProvider = FutureProvider.family<RoadMap?, String>((ref, mapId) async {
  if (mapId.isEmpty) return null;
  
  final roadmapService = ref.read(roadmapServiceProvider);
  final roadmapData = await roadmapService.fetchRoadMapById(mapId);

  ref.read(nodesNotifierProvider.notifier).setNodes(roadmapData.nodes);
  final nodes = ref.read(nodesNotifierProvider);

  return RoadMap(
    id: mapId,
    title: roadmapData.title,
    profile: roadmapData.profile,
    objective: roadmapData.objective,
    deadline: roadmapData.deadline,
    createdAt: roadmapData.createdAt,
    updatedAt: roadmapData.updatedAt,
    nodes: nodes,
  );
});
