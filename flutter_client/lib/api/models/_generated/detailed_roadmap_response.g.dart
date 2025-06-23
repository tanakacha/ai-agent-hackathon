// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../detailed_roadmap_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DetailedRoadmapResponseImpl _$$DetailedRoadmapResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DetailedRoadmapResponseImpl(
      mapId: json['mapId'] as String,
      nodes: (json['nodes'] as List<dynamic>)
          .map((e) => Node.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$DetailedRoadmapResponseImplToJson(
        _$DetailedRoadmapResponseImpl instance) =>
    <String, dynamic>{
      'mapId': instance.mapId,
      'nodes': instance.nodes,
      'message': instance.message,
    };
