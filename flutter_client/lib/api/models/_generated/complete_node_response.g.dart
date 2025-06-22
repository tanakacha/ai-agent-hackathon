// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../complete_node_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompleteNodeResponseImpl _$$CompleteNodeResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CompleteNodeResponseImpl(
      node: json['node'] == null
          ? null
          : Node.fromJson(json['node'] as Map<String, dynamic>),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$CompleteNodeResponseImplToJson(
        _$CompleteNodeResponseImpl instance) =>
    <String, dynamic>{
      'node': instance.node,
      'message': instance.message,
    };
