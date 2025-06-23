import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/complete_node_request.freezed.dart';
part '_generated/complete_node_request.g.dart';

@freezed
class CompleteNodeRequest with _$CompleteNodeRequest {
  const factory CompleteNodeRequest({
    required String mapId,
    required String nodeId,
  }) = _CompleteNodeRequest;

  factory CompleteNodeRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteNodeRequestFromJson(json);
}
