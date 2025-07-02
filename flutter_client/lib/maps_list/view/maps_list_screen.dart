import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app_router.dart';
import '../../auth/view_model/auth_notifier.dart';
import '../../main_app/view_model/main_app_notifier.dart';
import '../view_model/maps_list_notifier.dart';

class MapsListScreen extends HookConsumerWidget {
  final String uid;

  const MapsListScreen({
    super.key,
    required this.uid,
  });

  String formatDeadline(String? deadline) {
    if (deadline == null) return '';
    try {
      final parts = deadline.split(' ');
      if (parts.length >= 4) {
        return '${parts[1]} ${parts[2]}, ${parts.last}';
      }
      return deadline;
    } catch (e) {
      return deadline;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapsListState = ref.watch(mapsListNotifierProvider);
    final mapsListNotifier = ref.read(mapsListNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    final mainAppNotifier = ref.read(mainAppNotifierProvider.notifier);

    useEffect(() {
      Future.microtask(() async {
        await mapsListNotifier.loadUserMaps(uid);
        // MainAppNotifierを初期化
        authState.whenOrNull(
          authenticated: (user, isNewUser) => mainAppNotifier.initializeUser(user),
        );
      });
      return null;
    }, [uid]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイロードマップ'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
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
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => mapsListNotifier.loadUserMaps(uid),
          ),
        ],
      ),
      body: mapsListState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (maps) {
          if (maps.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'まだロードマップがありません',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '新しいロードマップを作成しましょう',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('${AppRoutes.goalInput}?uid=$uid');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('新しいロードマップを作成'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'ロードマップ一覧 (${maps.length}件)',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.go('${AppRoutes.goalInput}?uid=$uid');
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('新規作成'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: maps.length,
                  itemBuilder: (context, index) {
                    final map = maps[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            Icons.map,
                            color: Colors.blue[700],
                            size: 24,
                          ),
                        ),
                        title: Text(
                          map.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              map.objective,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            if (map.deadline != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '期限: ${formatDeadline(map.deadline)}',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          context.go('${AppRoutes.roadmapDisplay}?mapId=${map.mapId}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (message) => Center(
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
                'エラーが発生しました',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => mapsListNotifier.loadUserMaps(uid),
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
  }
}
