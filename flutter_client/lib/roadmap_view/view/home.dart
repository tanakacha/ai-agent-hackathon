import 'package:flutter/material.dart';
import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/providers/roadmap_provider.dart';
import 'package:flutter_client/roadmap_view/utils/default_tree_layout_algorithm.dart';
import 'package:flutter_client/roadmap_view/widget/roadmap_widget.dart';
import 'package:flutter_client/widgets/node_detail_modal.dart';
import 'package:flutter_client/auth/view_model/auth_notifier.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app_router.dart';

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
          ).then((_) {
            ref.read(roadmapNotifierProvider.notifier).refreshRoadmap();
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(roadMap.title),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            actions: [
              PopupMenuButton<String>(
                onSelected: (String value) async {
                  if (value == 'logout') {
                    try {
                      await ref.read(authNotifierProvider.notifier).signOut();
                      if (context.mounted) {
                        context.go(AppRoutes.auth);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ログアウトに失敗しました: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('ログアウト'),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
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
    // ログには詳細出力
    debugPrint('[ErrorWidget] error: $error');
    debugPrint('[ErrorWidget] stackTrace:\n$stackTrace');

    return Scaffold(
      appBar: AppBar(
        title: const Text('エラー'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'エラーが発生しました。',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                debugPrint('[_buildErrorWidget] Retry pressed');
                ref.invalidate(roadmapNotifierProvider);
              },
              child: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }
}
