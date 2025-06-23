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
      completedNodes: (json['completedNodes'] as List<dynamic>?)
              ?.map((e) => Node.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      message: json['message'] as String,
    );

Map<String, dynamic> _$$CompleteNodeResponseImplToJson(
        _$CompleteNodeResponseImpl instance) =>
    <String, dynamic>{
      'node': instance.node,
      'completedNodes': instance.completedNodes,
      'message': instance.message,
    };
