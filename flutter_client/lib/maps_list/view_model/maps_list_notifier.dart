import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/repository/user_api_service.dart';
import 'maps_list_state.dart';

part '_generated/maps_list_notifier.g.dart';

@riverpod
class MapsListNotifier extends _$MapsListNotifier {
  @override
  MapsListState build() {
    return const MapsListState.initial();
  }

  Future<void> loadUserMaps(String userId) async {
    state = const MapsListState.loading();
    
    try {
      final userApiService = ref.read(userApiServiceProvider);
      final response = await userApiService.getUserMaps(userId: userId);
      
      state = MapsListState.success(response.maps);
    } catch (e) {
      state = MapsListState.error('マップ一覧の取得中にエラーが発生しました: ${e.toString()}');
    }
  }
}
