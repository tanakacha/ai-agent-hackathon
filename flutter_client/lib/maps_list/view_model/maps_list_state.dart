import 'package:freezed_annotation/freezed_annotation.dart';
import '../../auth/repository/user_profile_dto.dart';

part '_generated/maps_list_state.freezed.dart';

@freezed
class MapsListState with _$MapsListState {
  const factory MapsListState.initial() = _Initial;
  const factory MapsListState.loading() = _Loading;
  const factory MapsListState.success(List<MapSummary> maps) = _Success;
  const factory MapsListState.error(String message) = _Error;
}
