import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/goal_input_state.freezed.dart';

@freezed
class GoalInputState with _$GoalInputState {
  const factory GoalInputState.initial() = _Initial;
  const factory GoalInputState.loading() = _Loading;
  const factory GoalInputState.success(String mapId) = _Success;
  const factory GoalInputState.error(String message) = _Error;
}
