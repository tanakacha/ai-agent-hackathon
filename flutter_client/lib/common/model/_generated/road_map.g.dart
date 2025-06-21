// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../road_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoadMapImpl _$$RoadMapImplFromJson(Map<String, dynamic> json) =>
    _$RoadMapImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      objective: json['objective'] as String,
      profile: json['profile'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      nodes: (json['nodes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Node.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$RoadMapImplToJson(_$RoadMapImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'objective': instance.objective,
      'profile': instance.profile,
      'deadline': instance.deadline.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'nodes': instance.nodes,
    };
