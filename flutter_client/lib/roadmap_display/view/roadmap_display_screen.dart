import 'package:flutter/material.dart';
import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/roadmap_view/utils/default_tree_layout_algorithm.dart';
import 'package:flutter_client/roadmap_view/widget/roadmap_widget.dart';
import 'package:flutter_client/widgets/node_detail_modal.dart';
import 'package:flutter_client/auth/view_model/auth_notifier.dart';
import 'package:flutter_client/app_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_model/roadmap_display_notifier.dart';

class RoadmapDisplayScreen extends HookConsumerWidget {
  final String mapId;

  const RoadmapDisplayScreen({
    super.key,
    required this.mapId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadMapAsync = ref.watch(roadmapDisplayNotifierProvider(mapId));

    useEffect(() {
      debugPrint('[useEffect] RoadmapDisplayScreen mounted with mapId: $mapId');
      return null;
    }, [mapId]);

    return roadMapAsync.when(
      data: (roadMap) {
        if (roadMap == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('ロードマップが見つかりません'),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: Text('指定されたマップIDのロードマップが見つかりません'),
            ),
          );
        }

        debugPrint(
            '[data] RoadMap loaded: ${roadMap.title} (nodes: ${roadMap.nodes.length})');

        final layout = DefaultTreeLayoutAlgorithm();
        final rootNodes = roadMap.nodes.values
            .where((node) =>
                node.parentId == null || !roadMap.nodes.containsKey(node.parentId))
            .toList();

        final roadmapKey =
            useMemoized(() => GlobalKey<RoadmapWidgetState>(), [mapId]);
        final currentFocusIndex = useState(0);
        final selectedNodeId = useState<String?>(null);
        late final Map<String, Node> updatedNodes;

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

        Node? findDeepestNode(Map<String, Node> nodes) {
          int calculateDepth(String nodeId, Map<String, Node> nodeMap) {
            final node = nodeMap[nodeId];
            if (node == null) return -1;
            if (node.parentId == null || !nodeMap.containsKey(node.parentId)) {
              return 0;
            }
            return 1 + calculateDepth(node.parentId!, nodeMap);
          }

          Node? targetNode;
          int maxDepth = -1;
          for (final node in nodes.values) {
            if (node.nodeType != NodeType.root) {
              final depth = calculateDepth(node.id, nodes);
              if (depth > maxDepth) {
                maxDepth = depth;
                targetNode = node;
              }
            }
          }
          return targetNode;
        }

        Node? findShallowIncompleteNode(Map<String, Node> nodes) {
          Node? rootNode;
          try {
            rootNode = nodes.values.firstWhere(
              (node) => node.nodeType == NodeType.root,
            );
          } catch (e) {
            return findDeepestNode(nodes);
          }

          Node? findIncompleteLeafNode(String nodeId) {
            var currentNodeId = nodeId;
            
            while (true) {
              final currentNode = nodes[currentNodeId];
              if (currentNode == null) return null;
              
              if (currentNode.childrenIds.isEmpty) {
                return currentNode;
              }
              
              String? nextIncompleteChildId;
              for (final childId in currentNode.childrenIds) {
                final childNode = nodes[childId];
                if (childNode != null && 
                    childNode.nodeType == NodeType.normal && 
                    childNode.progressRate < 100) {
                  nextIncompleteChildId = childId;
                  break;
                }
              }
              
              if (nextIncompleteChildId == null) {
                return currentNode;
              }
              
              currentNodeId = nextIncompleteChildId;
            }
          }

          Node? dfsSearch(String nodeId, Set<String> visited) {
            if (visited.contains(nodeId)) return null;
            visited.add(nodeId);
            
            final currentNode = nodes[nodeId];
            if (currentNode == null) return null;

            if (currentNode.nodeType == NodeType.normal && currentNode.progressRate < 100) {
              return findIncompleteLeafNode(nodeId);
            }
            
            for (final childId in currentNode.childrenIds) {
              final result = dfsSearch(childId, visited);
              if (result != null) {
                return result;
              }
            }

            return null;
          }

          final visited = <String>{};
          final result = dfsSearch(rootNode.id, visited);

          if (result != null) {
            return result;
          }
          return findDeepestNode(nodes);
        }

        useMemoized(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final targetNode = findShallowIncompleteNode(updatedNodes);
            if (targetNode != null) {
              final state = roadmapKey.currentState;
              state?.focusNode(targetNode.id);
            }
          });
          return null;
        }, [mapId]);

        void focusNextNode() {
          final nodeIds = roadMap.nodes.keys.toList();
          if (nodeIds.isEmpty) {
            debugPrint('[focusNextNode] No nodes to focus');
            return;
          }
          currentFocusIndex.value =
              ((currentFocusIndex.value + 1) % nodeIds.length);
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
            ref.invalidate(roadmapDisplayNotifierProvider(mapId));
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(roadMap.title),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(roadmapDisplayNotifierProvider(mapId));
                },
              ),
              PopupMenuButton<String>(
                onSelected: (String value) async {
                  if (value == 'logout') {
                    try {
                      await ref.read(authNotifierProvider.notifier).signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const AppRouter()),
                          (route) => false,
                        );
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
                  child: Text(
                    '状態: 読み込み成功 (${roadMap.nodes.length}ノード) - ID: $mapId',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              RoadmapWidget(
                key: roadmapKey,
                nodes: updatedNodes,
                selectedNodeId: selectedNodeId.value,
                onNodeTap: handleNodeTap,
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: focusNextNode,
                  backgroundColor: Colors.blue,
                  child: Text(
                    (currentFocusIndex.value + 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('読み込み中...'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('ロードマップを読み込み中...'),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) {
        debugPrint('[error] Failed to load roadmap: $error');
        return Scaffold(
          appBar: AppBar(
            title: const Text('エラー'),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ロードマップの読み込みに失敗しました',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'マップID: $mapId',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'エラー: $error',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(roadmapDisplayNotifierProvider(mapId));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('再試行'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
