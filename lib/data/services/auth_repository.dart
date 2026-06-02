import 'package:dio/dio.dart';
import '../models/responses.dart';
import 'api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  // 🔥 LOGIN
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      // 🔥 JIKA LOGIN BERHASIL, SIMPAN TOKEN
      if (loginResponse.token != null) {
        await
        _apiService.setToken(loginResponse.token!);
      }

      return loginResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 🔥 GET CURRENT USER
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] && data['data'] != null) {
          return User.fromJson(data['data']);
        }
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 🔥 LOGOUT
  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
      _apiService.clearToken();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 🔥 ERROR HANDLER
  String _handleError(DioException error) {
    if (error.response != null) {
      final errorData = error.response?.data;
      if (errorData is Map && errorData.containsKey('message')) {
        return errorData['message'] ?? 'Unknown error';
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Invalid response from server.';
      default:
        return error.message ?? 'An error occurred';
    }
  }
}
