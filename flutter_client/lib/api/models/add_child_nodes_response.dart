import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/model/node.dart';

part '_generated/add_child_nodes_response.freezed.dart';
part '_generated/add_child_nodes_response.g.dart';

@freezed
class AddChildNodesResponse with _$AddChildNodesResponse {
  const factory AddChildNodesResponse({
    required String parentNodeId,
    required List<Node> childNodes,
    required String message,
  }) = _AddChildNodesResponse;

  factory AddChildNodesResponse.fromJson(Map<String, dynamic> json) =>
      _$AddChildNodesResponseFromJson(json);
}
