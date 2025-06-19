import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/add_child_nodes_request.freezed.dart';
part '_generated/add_child_nodes_request.g.dart';

@freezed
class AddChildNodesRequest with _$AddChildNodesRequest {
  const factory AddChildNodesRequest({
    required String mapId,
    required String nodeId,
  }) = _AddChildNodesRequest;

  factory AddChildNodesRequest.fromJson(Map<String, dynamic> json) =>
      _$AddChildNodesRequestFromJson(json);
}
