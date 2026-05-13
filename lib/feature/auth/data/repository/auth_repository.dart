import 'package:bagus_project/feature/auth/data/models/user_models.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/storage/local_storage.dart';
// import '../models/user_model.dart';

class AuthRepository {
  final ApiClient apiClient;
  final LocalStorage localStorage;

  AuthRepository({required this.apiClient, required this.localStorage});

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      final user = UserModel.fromJson(response.data);

      await localStorage.saveToken(user.accessToken);
      await localStorage.saveUser(user.toRawJson());

      return user;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login gagal');
    }
  }

  Future<void> logout() async {
    await localStorage.clearToken();
  }
}
