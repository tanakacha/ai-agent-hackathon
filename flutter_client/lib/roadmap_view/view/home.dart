import 'package:flutter/material.dart';
import 'package:flutter_client/providers/roadmap_provider.dart';
import 'package:flutter_client/roadmap_view/utils/default_tree_layout_algorithm.dart';
import 'package:flutter_client/roadmap_view/widget/roadmap_widget.dart';
import 'package:flutter_client/widgets/node_detail_modal.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoadMapDetailScreen extends HookConsumerWidget {
  final String roadMapId = "map-5678";

  const RoadMapDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadMapAsync = ref.watch(roadmapNotifierProvider);

    // 初回読み込み用: すでにデータがある or 読み込み中なら呼ばない
    useEffect(() {
      if (!roadMapAsync.isLoading &&
          roadMapAsync.hasError == false &&
          roadMapAsync.value == null) {
        ref.read(roadmapNotifierProvider.notifier).loadRoadmapById(roadMapId);
      }
      return null;
    }, []);

    return roadMapAsync.when(
      data: (roadMap) {
        // 以下はあなたの既存の表示ロジックそのままでOK
        final layout = DefaultTreeLayoutAlgorithm();
        final rootNodes =
            ref.read(roadmapNotifierProvider.notifier).getRootNodes();

        final roadmapKey =
            useMemoized(() => GlobalKey<RoadmapWidgetState>(), [roadMapId]);

        final currentFocusIndex = useState(0);
        final selectedNodeId = useState<String?>(null);

        try {
          layout.calculatePositions(
            nodes: roadMap.nodes,
            rootNodes: rootNodes,
            spaceX: 120,
            spaceY: 100,
          );
        } catch (e, st) {
          debugPrint('位置計算中にエラー: $e\n$st');
          rethrow;
        }

        void focusNextNode() {
          final nodeIds = roadMap.nodes.keys.toList();
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
          showDialog(
            context: context,
            builder: (context) => NodeDetailModal(nodeId: nodeId),
          );
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
                nodes: roadMap.nodes,
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
            onPressed: () => ref
                .read(roadmapNotifierProvider.notifier)
                .loadRoadmapById("map-5678"),
            child: const Text('再試行'),
          ),
        ],
      ),
    );
  }
}
