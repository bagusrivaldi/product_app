import 'package:bagus_project/feature/auth/data/models/user_models.dart';
import 'package:bagus_project/feature/auth/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/storage/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final LocalStorage localStorage;

  AuthProvider({required this.authRepository, required this.localStorage});

  UserModel? user;
  bool isLoading = false;
  String? errorMessage;

  Future<void> login(String username, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      user = await authRepository.login(username: username, password: password);
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    user = null;
    notifyListeners();
  }

  Future<void> loadUserFromStorage() async {
    final rawUser = await localStorage.getUser();

    if (rawUser != null) {
      user = UserModel.fromRawJson(rawUser);
      notifyListeners();
    }
  }

  Future<bool> hasToken() async {
    final token = await localStorage.getToken();

    if (token != null && token.isNotEmpty) {
      await loadUserFromStorage();
      return true;
    }

    return false;
  }
}
