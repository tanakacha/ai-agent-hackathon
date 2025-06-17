// providers/api_provider.dart
import 'package:flutter_client/common/model/road_map.dart';
import 'package:flutter_client/common/service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// 特定のロードマップをフェッチするプロバイダー
final roadMapProvider = FutureProvider.family<RoadMap, String>((ref, id) async {
  final apiService = ref.read(apiServiceProvider);
  final result = await apiService.fetchRoadMapById(id);
  print(result);
  return result;
});
