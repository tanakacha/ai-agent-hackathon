// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../add_child_nodes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddChildNodesResponseImpl _$$AddChildNodesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AddChildNodesResponseImpl(
      parentNodeId: json['parentNodeId'] as String,
      childNodes: (json['childNodes'] as List<dynamic>)
          .map((e) => Node.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$AddChildNodesResponseImplToJson(
        _$AddChildNodesResponseImpl instance) =>
    <String, dynamic>{
      'parentNodeId': instance.parentNodeId,
      'childNodes': instance.childNodes,
      'message': instance.message,
    };
