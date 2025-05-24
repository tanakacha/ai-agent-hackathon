// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Flow Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Flow Chart Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dashboard dashboard = Dashboard();

  @override
  void initState() {
    super.initState();
    _addInitialElements();
  }

  void _addInitialElements() {
    final node1 = FlowElement(
      position: const Offset(100, 100),
      size: const Size(100, 50),
      text: 'Node 1',
      handlerSize: 25,
      kind: ElementKind.rectangle,
      handlers: [
        Handler.bottomCenter,
        Handler.topCenter,
        Handler.leftCenter,
        Handler.rightCenter,
      ],
      isConnectable: false,
      isDraggable: false,
      isResizable: false,
    );

    final node2 = FlowElement(
      position: const Offset(300, 200),
      size: const Size(200, 100),
      text: 'Node 2',
      handlerSize: 25,
      kind: ElementKind.rectangle,
      handlers: [
        Handler.bottomCenter,
        Handler.topCenter,
        Handler.leftCenter,
        Handler.rightCenter,
      ],
    );

    dashboard.addElement(node1);
    dashboard.addElement(node2);
    dashboard
        .setGridBackgroundParams(GridBackgroundParams(gridColor: Colors.black));

    var arrowParams = ArrowParams();

    dashboard.addNextById(
      node1, // sourceElement の ID
      node2.id, // destId
      arrowParams,
    );
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              dashboard.setZoomFactor(1.5 * dashboard.zoomFactor);
            },
            icon: const Icon(Icons.zoom_in),
          ),
          IconButton(
            onPressed: () {
              dashboard.setZoomFactor(dashboard.zoomFactor / 1.5);
            },
            icon: const Icon(Icons.zoom_out),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    "https://i.pinimg.com/originals/bf/6e/54/bf6e5417ac0c146f175983a491839876.jpg"))),
        child: FlowChart(
          dashboard: dashboard,
          onNewConnection: (p1, p2) {
            debugPrint('new connection');
          },
          // ダッシュボードや要素のタップ時のメニュー表示を削除
          onDashboardTapped: (context, position) {
            debugPrint('Dashboard tapped $position');
          },
          onElementPressed: (context, position, element) {
            debugPrint('Element with "${element.text}" text pressed');
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              dashboard.addElement(
                FlowElement(
                  position: const Offset(200, 300), // 適当な位置
                  size: const Size(100, 50),
                  text: 'New Node ${dashboard.elements.length}',
                  handlerSize: 25,
                  kind: ElementKind.rectangle,
                  handlers: [
                    Handler.bottomCenter,
                    Handler.topCenter,
                    Handler.leftCenter,
                    Handler.rightCenter,
                  ],
                ),
              );
            },
            heroTag: 'add_node',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: dashboard.recenter,
            heroTag: 'recenter',
            child: const Icon(Icons.center_focus_strong),
          ),
        ],
      ),
    );
  }
}
