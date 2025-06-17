import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/common/model/node.dart';
import 'package:flutter_client/common/model/road_map.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://javabackend-229610582553.asia-northeast1.run.app/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<RoadMap> fetchRoadMapById(String id) async {
    try {
      final response = await _dio.get('/roadmap/roadmap/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to load roadmap: ${response.statusCode}');
      }

      final roadMap = RoadMap.fromJson(response.data);
      debugPrint('roadmap: $roadMap');

      final nodeResponse = await _dio.get('/roadmap/roadmap/$id/nodes');
      if (nodeResponse.statusCode == 200) {
        final nodes = (nodeResponse.data as List<dynamic>)
            .map((e) => Node.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('nodes: $nodes');
        roadMap.setNodes(nodes);
      }
      debugPrint('roadmap: $roadMap');

      return roadMap;
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
