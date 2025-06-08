// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import 'common/core/default_tree_layout_algorithm.dart';
import 'common/sample_data/node_list.dart';
import 'common/widget/roadmap_widget.dart';

void main() {
  // ノード位置を自動計算
  final layout = DefaultTreeLayoutAlgorithm();
  final rootNodes =
      sampleNodes.values.where((n) => n.parentId == null).toList();
  layout.calculatePositions(
    nodes: sampleNodes,
    rootNodes: rootNodes,
    spaceX: 100,
    spaceY: 100,
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
      home: Scaffold(
        appBar: AppBar(title: const Text('Sample Roadmap')),
        body: RoadmapWidget(
          nodes: sampleNodes,
        ),
      ),
    );
  }
}
