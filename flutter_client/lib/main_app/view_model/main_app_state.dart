import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/main_app_state.freezed.dart';

@freezed
class MainAppState with _$MainAppState {
  const factory MainAppState.initial() = _Initial;
  const factory MainAppState.loading() = _Loading;
  const factory MainAppState.needsProfile() = _NeedsProfile;
  const factory MainAppState.hasMaps() = _HasMaps;
  const factory MainAppState.noMap() = _NoMap;
  const factory MainAppState.error(String message) = _Error;
}
