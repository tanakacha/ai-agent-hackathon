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
      
      // まず既存のユーザーかチェック
      final checkMapResponse = await userApiService.checkUserMap(
        userId: user.uid,
      );
      
      if (checkMapResponse.hasMap) {
        // 既存ユーザーでマップがある場合はマップ一覧画面へ
        state = const MainAppState.hasMaps();
      } else {
        // 新規ユーザーまたはマップがない場合
        // ユーザープロファイルが作成されているかチェック
        try {
          await userApiService.createUser(
            uid: user.uid,
            email: user.email ?? '',
          );
          // 既存のcreateUserが成功した場合は既存ユーザー（プロファイル未設定）
          state = const MainAppState.needsProfile();
        } catch (e) {
          // createUserが失敗した場合は既存ユーザー（プロファイル設定済み）
          state = const MainAppState.noMap();
        }
      }
    } catch (e) {
      state = MainAppState.error('初期化中にエラーが発生しました: ${e.toString()}');
    }
  }
}
