import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/user_profile_state.freezed.dart';

@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState.initial() = _Initial;
  const factory UserProfileState.loading() = _Loading;
  const factory UserProfileState.success() = _Success;
  const factory UserProfileState.error(String message) = _Error;
}
