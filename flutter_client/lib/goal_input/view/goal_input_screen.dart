import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app_router.dart';
import '../view_model/goal_input_notifier.dart';
import '../view_model/goal_input_state.dart';

class GoalInputScreen extends HookConsumerWidget {
  final String uid;

  const GoalInputScreen({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalController = useTextEditingController();
    final deadlineController = useTextEditingController();
    
    final goalInputState = ref.watch(goalInputNotifierProvider);
    final goalInputNotifier = ref.read(goalInputNotifierProvider.notifier);

    Future<void> selectDate() async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: now.add(const Duration(days: 30)),
        firstDate: now,
        lastDate: now.add(const Duration(days: 365)),
      );
      
      if (picked != null) {
        deadlineController.text = picked.toIso8601String().split('T')[0];
      }
    }

    Future<void> handleSubmit() async {
      if (goalController.text.trim().isEmpty || deadlineController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('目標と期限を入力してください')),
        );
        return;
      }

      await goalInputNotifier.createRoadmap(
        uid: uid,
        goal: goalController.text.trim(),
        deadline: deadlineController.text.trim(),
      );
    }

    ref.listen<GoalInputState>(goalInputNotifierProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        success: (mapId) {
          // go_routerを使用してロードマップ表示画面に遷移
          context.go('${AppRoutes.roadmapDisplay}?mapId=$mapId');
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('目標設定'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('${AppRoutes.userProfile}?uid=$uid'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.flag,
              size: 60,
              color: Colors.blue[700],
            ),
            const SizedBox(height: 16),
            Text(
              '目標を設定してください',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'あなたが達成したい目標と期限を教えてください。AIが最適なロードマップを作成します。',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            
            // 目標入力
            TextField(
              controller: goalController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '目標',
                hintText: '例: Webアプリケーションを開発できるようになりたい',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Icon(Icons.stars),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            
            // 期限入力
            TextField(
              controller: deadlineController,
              readOnly: true,
              onTap: selectDate,
              decoration: InputDecoration(
                labelText: '期限',
                hintText: '期限を選択してください',
                prefixIcon: const Icon(Icons.calendar_today),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'ヒント',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• 具体的で明確な目標を設定してください\n'
                    '• 実現可能な期限を設定してください\n'
                    '• プロファイル情報を基に最適なロードマップを作成します',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: goalInputState.maybeWhen(
                  loading: () => null,
                  orElse: () => handleSubmit,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: goalInputState.maybeWhen(
                  loading: () => const CircularProgressIndicator(color: Colors.white),
                  orElse: () => const Text(
                    'ロードマップを作成',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
