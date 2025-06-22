import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_model/main_app_notifier.dart';
import '../../map_input/view/map_input_screen.dart';
import '../../roadmap_display/view/roadmap_display_screen.dart';

class MainAppScreen extends HookConsumerWidget {
  final User user;

  const MainAppScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainAppState = ref.watch(mainAppNotifierProvider);
    final mainAppNotifier = ref.read(mainAppNotifierProvider.notifier);

    useEffect(() {
      Future.microtask(() => mainAppNotifier.initializeUser(user));
      return null;
    }, []);

    return mainAppState.when(
      initial: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      hasMap: (mapId) => RoadmapDisplayScreen(mapId: mapId),
      noMap: () => const MapInputScreen(),
      error: (message) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('エラー: $message'),
              ElevatedButton(
                onPressed: () => mainAppNotifier.initializeUser(user),
                child: const Text('再試行'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
