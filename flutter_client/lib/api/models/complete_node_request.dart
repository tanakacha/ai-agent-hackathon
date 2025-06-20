class CompleteNodeRequest {
  final String mapId;
  final String nodeId;

  CompleteNodeRequest({
    required this.mapId,
    required this.nodeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'mapId': mapId,
      'nodeId': nodeId,
    };
  }
}
