import 'package:flutter/material.dart';
import 'package:flutter_client/common/model/node.dart';
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

    // 状態遷移ログ
    useEffect(() {
      debugPrint('[useEffect] RoadMapDetailScreen mounted');
      if (!roadMapAsync.isLoading &&
          !roadMapAsync.hasError &&
          roadMapAsync.value == null) {
        debugPrint('[useEffect] Trigger fetch roadmap: $roadMapId');
        ref.read(roadmapNotifierProvider.notifier);
      }
      return null;
    }, [roadMapAsync]); // 依存配列で状態が変わるたびに呼ばれる

    return roadMapAsync.when(
      data: (roadMap) {
        debugPrint(
            '[data] RoadMap loaded: ${roadMap.title} (nodes: ${roadMap.nodes.length})');

        final layout = DefaultTreeLayoutAlgorithm();
        final rootNodes =
            ref.read(roadmapNotifierProvider.notifier).getRootNodes();

        final roadmapKey =
            useMemoized(() => GlobalKey<RoadmapWidgetState>(), [roadMapId]);
        final currentFocusIndex = useState(0);
        final selectedNodeId = useState<String?>(null);
        late final Map<String, Node> updatedNodes;

        // ノードの位置計算
        try {
          debugPrint('[data] Layout calculation start...');
          updatedNodes = layout.calculatePositions(
            nodes: roadMap.nodes,
            rootNodes: rootNodes,
            spaceX: 120,
            spaceY: 100,
          );
          debugPrint('[data] Layout calculation completed');
        } catch (e, st) {
          debugPrint('[data] Layout calculation ERROR: $e\n$st');
          rethrow;
        }

        void focusNextNode() {
          final nodeIds = roadMap.nodes.keys.toList();
          if (nodeIds.isEmpty) {
            debugPrint('[focusNextNode] No nodes to focus');
            return;
          }
          currentFocusIndex.value =
              (currentFocusIndex.value + 1) % nodeIds.length;
          final targetNodeId = nodeIds[currentFocusIndex.value];
          debugPrint(
              '[focusNextNode] Focus index: ${currentFocusIndex.value}, nodeId: $targetNodeId');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final state = roadmapKey.currentState;
            state?.focusNode(targetNodeId);
          });
        }

        void handleNodeTap(String nodeId) {
          debugPrint('[handleNodeTap] Tapped nodeId: $nodeId');
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
              Positioned(
                left: 16,
                top: 8,
                child: Container(
                  color: Colors.white70,
                  child: Text('状態: 読み込み成功 (${roadMap.nodes.length}ノード)',
                      style: const TextStyle(fontSize: 12)),
                ),
              ),
              RoadmapWidget(
                key: roadmapKey,
                nodes: updatedNodes,
                selectedNodeId: selectedNodeId.value,
                onNodeTap: handleNodeTap,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    debugPrint('[FAB] focusNextNode() pressed');
                    focusNextNode();
                  },
                  child: const Icon(Icons.navigate_next),
                ),
              ),
            ],
          ),
        );
      },
      loading: () {
        debugPrint('[loading] RoadMapDetailScreen: 読み込み中...');
        return Scaffold(
          appBar: AppBar(
            title: const Text('読み込み中...'),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('ロードマップ読込中'),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        debugPrint('[error] RoadMapDetailScreen: $error\n$stackTrace');
        return _buildErrorWidget(error, ref, stackTrace);
      },
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
            onPressed: () {
              debugPrint('[_buildErrorWidget] Retry pressed');
              ref.invalidate(roadmapNotifierProvider);
            },
            child: const Text('再試行'),
          ),
        ],
      ),
    );
  }
}
