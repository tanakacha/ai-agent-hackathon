import 'package:flutter/material.dart';
import 'package:flutter_client/providers/roadmap_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/nodes_provider.dart';

class NodeDetailModal extends HookConsumerWidget {
  final String nodeId;

  const NodeDetailModal({
    super.key,
    required this.nodeId,
  }); 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isCompleting = useState(false);
    final nodes = ref.read(nodesNotifierProvider);
    final node = nodes[nodeId];

    if (node == null) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(24),
          child: const Center(
            child: Text('ノードが見つかりません'),
          ),
        ),
      );
    }

    Future<void> handleDeepDivePressed() async {
      if (isLoading.value) return;

      isLoading.value = true;
      try {
        ref.read(roadmapNotifierProvider.notifier).addChildNodesToParent(
            roadmapId: 'map-5678', parentId: nodeId // ここもnodeIdに変更
            );

        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('子ノードが正常に追加されました'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('エラーが発生しました: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> handleCompletePressed() async {
      if (isCompleting.value) return;

      isCompleting.value = true;
      try {
        await ref.read(nodesNotifierProvider.notifier).completeNode(
          mapId: node.mapId ?? 'map-5678',
          nodeId: node.id,
        );

        try {
          await ref.read(roadmapNotifierProvider.notifier).refreshRoadmap();
        } catch (e) {
          debugPrint('Failed to refresh roadmap: $e');
        }

        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ノードが正常に完了しました'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('エラーが発生しました: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        isCompleting.value = false;
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              node.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // 薄いライン
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: 20),

            // 詳細情報
            _buildDetailRow(
              context,
              icon: Icons.description,
              label: '詳細',
              value: node.description,
            ),

            const SizedBox(height: 12),

            _buildDetailRow(
              context,
              icon: Icons.schedule,
              label: '想定所要時間',
              value: '${node.duration}時間',
            ),

            const SizedBox(height: 12),

            _buildDetailRow(
              context,
              icon: Icons.trending_up,
              label: '進捗率',
              value: '${node.progressRate}%',
            ),

            const SizedBox(height: 12),

            _buildDetailRow(
              context,
              icon: Icons.event_available,
              label: '達成時刻',
              value: node.finishedAt != null
                  ? _formatDateTime(node.finishedAt!)
                  : '未達成',
            ),

            const SizedBox(height: 32),

            // 深掘るボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (isLoading.value || isCompleting.value) ? null : handleDeepDivePressed,
                icon: isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: Text(isLoading.value ? '追加中...' : '深掘る'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 完了ボタン（未完了の場合のみ表示）
            if (node.progressRate != 100) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (isLoading.value || isCompleting.value) ? null : handleCompletePressed,
                  icon: isCompleting.value 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                  label: Text(isCompleting.value ? '完了処理中...' : '完了'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // キャンセルボタン
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: isLoading.value || isCompleting.value ? null : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('閉じる'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
