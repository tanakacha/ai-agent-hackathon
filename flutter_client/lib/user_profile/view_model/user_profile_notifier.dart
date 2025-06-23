import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/repository/user_api_service.dart';
import '../../auth/repository/user_profile_dto.dart';
import 'user_profile_state.dart';

part '_generated/user_profile_notifier.g.dart';

@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  UserProfileState build() {
    return const UserProfileState.initial();
  }

  Future<void> createUserProfile({
    required String uid,
    required String nickname,
    required int age,
    required UserType userType,
    required int availableHoursPerDay,
    required int availableDaysPerWeek,
    required ExperienceLevel experienceLevel,
  }) async {
    state = const UserProfileState.loading();
    
    try {
      final userApiService = ref.read(userApiServiceProvider);
      
      await userApiService.createUserWithProfile(
        uid: uid,
        nickname: nickname,
        age: age,
        userType: userType,
        availableHoursPerDay: availableHoursPerDay,
        availableDaysPerWeek: availableDaysPerWeek,
        experienceLevel: experienceLevel,
      );
      
      state = const UserProfileState.success();
    } catch (e) {
      state = UserProfileState.error('プロファイル作成中にエラーが発生しました: ${e.toString()}');
    }
  }
}
