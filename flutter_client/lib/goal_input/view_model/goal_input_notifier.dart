import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../services/roadmap_service.dart';
import '../../auth/repository/user_profile_dto.dart';
import 'goal_input_state.dart';

part '_generated/goal_input_notifier.g.dart';

@riverpod
class GoalInputNotifier extends _$GoalInputNotifier {
  @override
  GoalInputState build() {
    return const GoalInputState.initial();
  }

  Future<void> createRoadmap({
    required String uid,
    required String goal,
    required String deadline,
  }) async {
    state = const GoalInputState.loading();
    
    try {
      // TODO: 一旦API呼び出しをコメントアウトして、固定のmapIdを使用
      // final roadmapService = ref.read(roadmapServiceProvider);
      
      // Create roadmap with user profile
      // final response = await roadmapService.createDetailedRoadmapWithUser(
      //   userId: uid,
      //   goal: goal,
      //   deadline: deadline,
      //   userType: UserType.student, // TODO: Get from user profile
      //   availableHoursPerDay: 2, // TODO: Get from user profile
      //   availableDaysPerWeek: 3, // TODO: Get from user profile
      //   experienceLevel: ExperienceLevel.beginner, // TODO: Get from user profile
      // );
      
      // 固定のmapIdを使用（テスト用）
      const fixedMapId = "map-5678";
      
      // 少し待機してローディング状態を見せる
      await Future.delayed(const Duration(seconds: 1));
      
      state = GoalInputState.success(fixedMapId);
    } on DioException catch (e) {
      String errorMessage = 'ロードマップ作成中にエラーが発生しました';
      if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'ロードマップ作成がタイムアウトしました。しばらく待ってから再試行してください。';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'サーバーへの接続がタイムアウトしました。';
      } else if (e.response != null) {
        errorMessage = '${errorMessage}: ${e.response?.statusCode} ${e.response?.statusMessage}';
      }
      state = GoalInputState.error(errorMessage);
    } catch (e) {
      state = GoalInputState.error('ロードマップ作成中にエラーが発生しました: ${e.toString()}');
    }
  }
}
