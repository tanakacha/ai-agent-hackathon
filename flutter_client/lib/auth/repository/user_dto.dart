import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/user_dto.freezed.dart';
part '_generated/user_dto.g.dart';

@freezed
class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String uid,
    required String email,
  }) = _CreateUserRequest;

  factory CreateUserRequest.fromJson(Map<String, Object?> json) =>
      _$CreateUserRequestFromJson(json);
}

@freezed
class CreateUserResponse with _$CreateUserResponse {
  const factory CreateUserResponse({
    String? id,
    String? message,
  }) = _CreateUserResponse;

  factory CreateUserResponse.fromJson(Map<String, Object?> json) =>
      _$CreateUserResponseFromJson(json);
}

@freezed
class CheckUserMapRequest with _$CheckUserMapRequest {
  const factory CheckUserMapRequest({
    required String userId,
  }) = _CheckUserMapRequest;

  factory CheckUserMapRequest.fromJson(Map<String, Object?> json) =>
      _$CheckUserMapRequestFromJson(json);
}

@freezed
class CheckUserMapResponse with _$CheckUserMapResponse {
  const factory CheckUserMapResponse({
    required bool hasMap,
    String? mapId,
    String? message,
  }) = _CheckUserMapResponse;

  factory CheckUserMapResponse.fromJson(Map<String, Object?> json) =>
      _$CheckUserMapResponseFromJson(json);
}