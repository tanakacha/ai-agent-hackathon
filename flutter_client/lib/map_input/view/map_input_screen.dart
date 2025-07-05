import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../roadmap_display/view/roadmap_display_screen.dart';

class MapInputScreen extends HookConsumerWidget {
  const MapInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapIdController = useTextEditingController(text: 'map-5678');

    void navigateToRoadmap() {
      final mapId = mapIdController.text.trim();
      if (mapId.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RoadmapDisplayScreen(mapId: mapId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('マップIDを入力してください'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Way25'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map,
                size: 80,
                color: Colors.blue[700],
              ),
              const SizedBox(height: 24),
              Text(
                'Way25',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'マップIDを入力してください',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: mapIdController,
                          decoration: InputDecoration(
                            labelText: 'マップID',
                            hintText: 'map-5678',
                            prefixIcon: const Icon(Icons.tag),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.blue[700]!,
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => navigateToRoadmap(),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: navigateToRoadmap,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('ロードマップを表示'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
