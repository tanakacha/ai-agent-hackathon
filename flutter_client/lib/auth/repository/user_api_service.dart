import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../api/api_client.dart';
import 'user_dto.dart';

part '_generated/user_api_service.g.dart';

@riverpod
UserApiService userApiService(UserApiServiceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserApiService(apiClient);
}

class UserApiService {
  final ApiClient _apiClient;

  UserApiService(this._apiClient);

  Future<CreateUserResponse> createUser({
    required String uid,
    required String email,
  }) async {
    final request = CreateUserRequest(
      uid: uid,
      email: email,
    );

    return _apiClient.handleResponse(
      _apiClient.dio.post(
        '/api/user/create',
        data: request.toJson(),
      ),
      (json) => CreateUserResponse.fromJson(json),
    );
  }

  Future<CheckUserMapResponse> checkUserMap({
    required String userId,
  }) async {
    final request = CheckUserMapRequest(userId: userId);

    return _apiClient.handleResponse(
      _apiClient.dio.post(
        '/api/user/check-map',
        data: request.toJson(),
      ),
      (json) => CheckUserMapResponse.fromJson(json),
    );
  }
}
