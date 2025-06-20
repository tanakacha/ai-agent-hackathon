import '../../common/model/node.dart';

class CompleteNodeResponse {
  final Node? node;
  final String message;

  CompleteNodeResponse({
    this.node,
    required this.message,
  });

  factory CompleteNodeResponse.fromJson(Map<String, dynamic> json) {
    return CompleteNodeResponse(
      node: json['node'] != null ? Node.fromJson(json['node']) : null,
      message: json['message'] ?? '',
    );
  }
}
