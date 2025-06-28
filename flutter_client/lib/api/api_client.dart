import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '_generated/api_client.g.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio();

  // Base URL - バックエンドのURLに置き換えてください
  dio.options.baseUrl = 'http://localhost:8080';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.sendTimeout = const Duration(seconds: 30);

  // Add AuthInterceptor
  dio.interceptors.add(AuthInterceptor());

  // Request/Response のロギング（開発時のみ）
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    logPrint: (obj) => print(obj), // ignore: avoid_print (開発時のみ使用)
  ));

  return dio;
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
}

class ApiClient {
  final Dio _dio;
  
  ApiClient(this._dio);
  
  // Make methods public
  Future<T> handleResponse<T>(
      Future<Response> future, T Function(dynamic) fromJson) async {
    try {
      final response = await future;
      if (response.statusCode == 200) {
        final data = response.data;
        if (data == null) {
          throw ApiException('Response body is null');
        }
        return fromJson(data);
      } else {
        throw ApiException(
            'HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  
  // Make dio getter public
  Dio get dio => _dio;
  
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Bad response: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.unknown:
      default:
        return 'Unknown error: ${e.message}';
    }
  }
}

class ApiException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  ApiException(this.message, [this.stackTrace]);
  
  @override
  String toString() => 'ApiException: $message\n$stackTrace';
}
