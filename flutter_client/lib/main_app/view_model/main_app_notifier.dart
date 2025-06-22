import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/repository/user_api_service.dart';
import 'main_app_state.dart';

part '_generated/main_app_notifier.g.dart';

@riverpod
class MainAppNotifier extends _$MainAppNotifier {
  @override
  MainAppState build() {
    return const MainAppState.initial();
  }

  Future<void> initializeUser(User user) async {
    state = const MainAppState.loading();
    
    try {
      final userApiService = ref.read(userApiServiceProvider);
      
      await userApiService.createUser(
        uid: user.uid,
        email: user.email ?? '',
      );
      
      final checkMapResponse = await userApiService.checkUserMap(
        userId: user.uid,
      );
      
      if (checkMapResponse.hasMap && checkMapResponse.mapId != null) {
        state = MainAppState.hasMap(checkMapResponse.mapId!);
      } else {
        state = const MainAppState.noMap();
      }
    } catch (e) {
      state = MainAppState.error('初期化中にエラーが発生しました: ${e.toString()}');
    }
  }
}
