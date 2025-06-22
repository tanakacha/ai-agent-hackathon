import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/model/node.dart';

part '_generated/complete_node_response.freezed.dart';
part '_generated/complete_node_response.g.dart';

@freezed
class CompleteNodeResponse with _$CompleteNodeResponse {
  const factory CompleteNodeResponse({
    Node? node,
    @Default([]) List<Node> completedNodes,
    required String message,
  }) = _CompleteNodeResponse;

  factory CompleteNodeResponse.fromJson(Map<String, dynamic> json) =>
      _$CompleteNodeResponseFromJson(json);
}
