// ignore_for_file: public_member_api_docs

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/roadmap_view/utils/default_tree_layout_algorithm.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'common/sample_data/node_list.dart';
import 'firebase_options.dart';
import 'roadmap_view/widget/roadmap_widget.dart';

Future<void> main() async {
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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
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

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final roadmapKey = useMemoized(() => GlobalKey<RoadmapWidgetState>());
    final currentFocusIndex = useState(0);
    final selectedNodeId = useState<int?>(null);

    void focusNextNode() {
      final nodeIds = sampleNodes.keys.toList();
      if (nodeIds.isEmpty) return;

      currentFocusIndex.value = (currentFocusIndex.value + 1) % nodeIds.length;
      roadmapKey.currentState?.focusNode(nodeIds[currentFocusIndex.value]);
    }

    void handleNodeTap(int nodeId) {
      selectedNodeId.value = nodeId;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sample Roadmap')),
      body: RoadmapWidget(
        key: roadmapKey,
        nodes: sampleNodes,
        selectedNodeId: selectedNodeId.value,
        onNodeTap: handleNodeTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: focusNextNode,
        child: Text(currentFocusIndex.value.toString()),
      ),
    );
  }
}
