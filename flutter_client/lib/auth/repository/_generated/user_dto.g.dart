// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateUserRequestImpl _$$CreateUserRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateUserRequestImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$$CreateUserRequestImplToJson(
        _$CreateUserRequestImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
    };

_$CreateUserResponseImpl _$$CreateUserResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateUserResponseImpl(
      id: json['id'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$CreateUserResponseImplToJson(
        _$CreateUserResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
    };

_$CheckUserMapRequestImpl _$$CheckUserMapRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckUserMapRequestImpl(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$CheckUserMapRequestImplToJson(
        _$CheckUserMapRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

_$CheckUserMapResponseImpl _$$CheckUserMapResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckUserMapResponseImpl(
      hasMap: json['hasMap'] as bool,
      mapId: json['mapId'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$CheckUserMapResponseImplToJson(
        _$CheckUserMapResponseImpl instance) =>
    <String, dynamic>{
      'hasMap': instance.hasMap,
      'mapId': instance.mapId,
      'message': instance.message,
    };
