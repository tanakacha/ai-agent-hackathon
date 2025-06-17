import 'package:flutter/material.dart';
import 'package:flutter_client/common/provider/api_provider.dart';
import 'package:flutter_client/roadmap_view/utils/default_tree_layout_algorithm.dart';
import 'package:flutter_client/roadmap_view/widget/roadmap_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoadMapDetailScreen extends HookConsumerWidget {
  final String roadMapId = "map-5678";

  const RoadMapDetailScreen({
    super.key,
    // required this.roadMapId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadMapAsync = ref.watch(roadMapProvider(roadMapId));
    return roadMapAsync.when(
      data: (roadMap) {
        final layout = DefaultTreeLayoutAlgorithm();
        final rootNodes =
            roadMap.nodes.where((n) => n.parentId == null).toList();

        final roadmapKey =
            useMemoized(() => GlobalKey<RoadmapWidgetState>(), [roadMapId]);

        final currentFocusIndex = useState(0);
        final selectedNodeId = useState<String?>(null);
        final nodeMap = convertListToNodeMap(roadMap.nodes);

        try {
          layout.calculatePositions(
            nodes: nodeMap,
            rootNodes: rootNodes,
            spaceX: 120,
            spaceY: 100,
          );
        } catch (e, st) {
          debugPrint('位置計算中にエラー: $e\n$st');
          rethrow;
        }

        void focusNextNode() {
          final nodeIds = nodeMap.keys.toList();
          if (nodeIds.isEmpty) return;

          currentFocusIndex.value =
              (currentFocusIndex.value + 1) % nodeIds.length;
          final targetNodeId = nodeIds[currentFocusIndex.value];

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final state = roadmapKey.currentState;
            state?.focusNode(targetNodeId);
          });
        }

        void handleNodeTap(String nodeId) {
          selectedNodeId.value = nodeId;
          final nodeIds = nodeMap.keys.toList();
          final index = nodeIds.indexOf(nodeId);
          if (index != -1) {
            currentFocusIndex.value = index;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(roadMap.title),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              RoadmapWidget(
                key: roadmapKey,
                nodes: nodeMap,
                selectedNodeId: selectedNodeId.value,
                onNodeTap: handleNodeTap,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: focusNextNode,
                  child: const Icon(Icons.navigate_next),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('読み込み中...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => _buildErrorWidget(error, ref, stackTrace),
    );
  }

  Widget _buildErrorWidget(Object error, WidgetRef ref, StackTrace stackTrace) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('エラーが発生しました: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(roadMapProvider(roadMapId)),
            child: const Text('再試行'),
          ),
        ],
      ),
    );
  }
}
