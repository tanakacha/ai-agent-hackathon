// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_client/roadmap_view/utils/default_tree_layout_algorithm.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'common/sample_data/node_list.dart';
import 'roadmap_view/widget/roadmap_widget.dart';
import 'providers/nodes_provider.dart';
import 'widgets/node_detail_modal.dart';

void main() {
  // ノード位置を自動計算
  final layout = DefaultTreeLayoutAlgorithm();
  final rootNodes =
      sampleNodes.values.where((n) => n.parentId == null).toList();
  layout.calculatePositions(
    nodes: sampleNodes,
    rootNodes: rootNodes,
    spaceX: 120,
    spaceY: 100,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roadmap Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmapKey = useMemoized(() => GlobalKey<RoadmapWidgetState>());
    final currentFocusIndex = useState(0);
    
    // Riverpodから状態を取得
    final nodes = ref.watch(nodesNotifierProvider);
    final selectedNodeId = ref.watch(selectedNodeNotifierProvider);

    void focusNextNode() {
      final nodeIds = nodes.keys.toList();
      if (nodeIds.isEmpty) return;

      currentFocusIndex.value = ((currentFocusIndex.value + 1) % nodeIds.length).toInt();
      roadmapKey.currentState?.focusNode(nodeIds[currentFocusIndex.value]);
    }

    void handleNodeTap(String nodeId) {
      ref.read(selectedNodeNotifierProvider.notifier).selectNode(nodeId);
      
      // ノードの詳細を取得してモーダルを表示
      final node = nodes[nodeId];
      if (node != null) {
        showDialog(
          context: context,
          builder: (context) => NodeDetailModal(node: node),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sample Roadmap')),
      body: RoadmapWidget(
        key: roadmapKey,
        nodes: nodes,
        selectedNodeId: selectedNodeId,
        onNodeTap: handleNodeTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: focusNextNode,
        child: Text(currentFocusIndex.value.toString()),
      ),
    );
  }
}
