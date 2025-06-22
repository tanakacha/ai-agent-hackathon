// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateUserWithProfileRequestImpl _$$CreateUserWithProfileRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateUserWithProfileRequestImpl(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      age: (json['age'] as num).toInt(),
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      availableHoursPerDay: (json['availableHoursPerDay'] as num).toInt(),
      availableDaysPerWeek: (json['availableDaysPerWeek'] as num).toInt(),
      experienceLevel:
          $enumDecode(_$ExperienceLevelEnumMap, json['experienceLevel']),
    );

Map<String, dynamic> _$$CreateUserWithProfileRequestImplToJson(
        _$CreateUserWithProfileRequestImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'age': instance.age,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'availableHoursPerDay': instance.availableHoursPerDay,
      'availableDaysPerWeek': instance.availableDaysPerWeek,
      'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
    };

const _$UserTypeEnumMap = {
  UserType.student: 'STUDENT',
  UserType.professional: 'PROFESSIONAL',
  UserType.freelancer: 'FREELANCER',
  UserType.hobbyist: 'HOBBYIST',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'BEGINNER',
  ExperienceLevel.intermediate: 'INTERMEDIATE',
  ExperienceLevel.advanced: 'ADVANCED',
  ExperienceLevel.expert: 'EXPERT',
};

_$CreateUserWithProfileResponseImpl
    _$$CreateUserWithProfileResponseImplFromJson(Map<String, dynamic> json) =>
        _$CreateUserWithProfileResponseImpl(
          uid: json['uid'] as String?,
          message: json['message'] as String?,
        );

Map<String, dynamic> _$$CreateUserWithProfileResponseImplToJson(
        _$CreateUserWithProfileResponseImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'message': instance.message,
    };

_$UserMapsListRequestImpl _$$UserMapsListRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UserMapsListRequestImpl(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$UserMapsListRequestImplToJson(
        _$UserMapsListRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

_$UserMapsListResponseImpl _$$UserMapsListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UserMapsListResponseImpl(
      maps: (json['maps'] as List<dynamic>)
          .map((e) => MapSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$UserMapsListResponseImplToJson(
        _$UserMapsListResponseImpl instance) =>
    <String, dynamic>{
      'maps': instance.maps,
      'message': instance.message,
    };

_$MapSummaryImpl _$$MapSummaryImplFromJson(Map<String, dynamic> json) =>
    _$MapSummaryImpl(
      mapId: json['mapId'] as String,
      title: json['title'] as String,
      objective: json['objective'] as String,
      deadline: json['deadline'] as String?,
    );

Map<String, dynamic> _$$MapSummaryImplToJson(_$MapSummaryImpl instance) =>
    <String, dynamic>{
      'mapId': instance.mapId,
      'title': instance.title,
      'objective': instance.objective,
      'deadline': instance.deadline,
    };

_$CreateDetailedRoadmapRequestImpl _$$CreateDetailedRoadmapRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateDetailedRoadmapRequestImpl(
      userId: json['userId'] as String,
      goal: json['goal'] as String,
      deadline: json['deadline'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      availableHoursPerDay: (json['availableHoursPerDay'] as num).toInt(),
      availableDaysPerWeek: (json['availableDaysPerWeek'] as num).toInt(),
      experienceLevel:
          $enumDecode(_$ExperienceLevelEnumMap, json['experienceLevel']),
    );

Map<String, dynamic> _$$CreateDetailedRoadmapRequestImplToJson(
        _$CreateDetailedRoadmapRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'goal': instance.goal,
      'deadline': instance.deadline,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'availableHoursPerDay': instance.availableHoursPerDay,
      'availableDaysPerWeek': instance.availableDaysPerWeek,
      'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
    };
