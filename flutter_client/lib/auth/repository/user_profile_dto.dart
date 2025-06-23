import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/user_profile_dto.freezed.dart';
part '_generated/user_profile_dto.g.dart';

@freezed
class CreateUserWithProfileRequest with _$CreateUserWithProfileRequest {
  const factory CreateUserWithProfileRequest({
    required String uid,
    required String nickname,
    required int age,
    required UserType userType,
    required int availableHoursPerDay,
    required int availableDaysPerWeek,
    required ExperienceLevel experienceLevel,
  }) = _CreateUserWithProfileRequest;

  factory CreateUserWithProfileRequest.fromJson(Map<String, Object?> json) =>
      _$CreateUserWithProfileRequestFromJson(json);
}

@freezed
class CreateUserWithProfileResponse with _$CreateUserWithProfileResponse {
  const factory CreateUserWithProfileResponse({
    String? uid,
    String? message,
  }) = _CreateUserWithProfileResponse;

  factory CreateUserWithProfileResponse.fromJson(Map<String, Object?> json) =>
      _$CreateUserWithProfileResponseFromJson(json);
}

@freezed
class UserMapsListRequest with _$UserMapsListRequest {
  const factory UserMapsListRequest({
    required String userId,
  }) = _UserMapsListRequest;

  factory UserMapsListRequest.fromJson(Map<String, Object?> json) =>
      _$UserMapsListRequestFromJson(json);
}

@freezed
class UserMapsListResponse with _$UserMapsListResponse {
  const factory UserMapsListResponse({
    required List<MapSummary> maps,
    String? message,
  }) = _UserMapsListResponse;

  factory UserMapsListResponse.fromJson(Map<String, Object?> json) =>
      _$UserMapsListResponseFromJson(json);
}

@freezed
class MapSummary with _$MapSummary {
  const factory MapSummary({
    required String mapId,
    required String title,
    required String objective,
    String? deadline,
  }) = _MapSummary;

  factory MapSummary.fromJson(Map<String, Object?> json) =>
      _$MapSummaryFromJson(json);
}

@freezed
class CreateDetailedRoadmapRequest with _$CreateDetailedRoadmapRequest {
  const factory CreateDetailedRoadmapRequest({
    required String userId,
    required String goal,
    required String deadline,
    required UserType userType,
    required int availableHoursPerDay,
    required int availableDaysPerWeek,
    required ExperienceLevel experienceLevel,
  }) = _CreateDetailedRoadmapRequest;

  factory CreateDetailedRoadmapRequest.fromJson(Map<String, Object?> json) =>
      _$CreateDetailedRoadmapRequestFromJson(json);
}

enum UserType {
  @JsonValue('STUDENT')
  student,
  @JsonValue('PROFESSIONAL')
  professional,
  @JsonValue('FREELANCER')
  freelancer,
  @JsonValue('HOBBYIST')
  hobbyist,
}

enum ExperienceLevel {
  @JsonValue('BEGINNER')
  beginner,
  @JsonValue('INTERMEDIATE')
  intermediate,
  @JsonValue('ADVANCED')
  advanced,
  @JsonValue('EXPERT')
  expert,
}
