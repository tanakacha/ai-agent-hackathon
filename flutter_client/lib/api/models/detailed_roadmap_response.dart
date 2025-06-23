import 'package:freezed_annotation/freezed_annotation.dart';
import '../../common/model/node.dart';

part '_generated/detailed_roadmap_response.freezed.dart';
part '_generated/detailed_roadmap_response.g.dart';

@freezed
class DetailedRoadmapResponse with _$DetailedRoadmapResponse {
  const factory DetailedRoadmapResponse({
    required String mapId,
    required List<Node> nodes,
    String? message,
  }) = _DetailedRoadmapResponse;

  factory DetailedRoadmapResponse.fromJson(Map<String, Object?> json) =>
      _$DetailedRoadmapResponseFromJson(json);
}
