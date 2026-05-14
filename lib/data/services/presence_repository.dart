import 'package:dio/dio.dart';
import '../models/responses.dart';
import 'api_service.dart';

class PresenceRepository {
  final ApiService _apiService = ApiService();

  // 🔥 CHECK-IN
  Future<PresenceResponse> checkIn({
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'latitude': latitude,
        'longitude': longitude,
        // 🔥 HARUS "photo"
        'photo': await MultipartFile.fromFile(
          photoPath,
          filename: 'selfie.jpg',
        ),
        'device_info': 'Android',
      });
      final response = await _apiService.post(
        '/presence/check-in',
        data: formData,
      );
      return PresenceResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("🔥 RESPONSE ERROR:");
      print(e.response?.data);
      throw _handleError(e);
    }
  }

  // 🔥 CHECK-OUT
  Future<PresenceResponse> checkOut({
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'latitude': latitude,
        'longitude': longitude,
        // 🔥 HARUS "photo"
        'photo': await MultipartFile.fromFile(
          photoPath,
          filename: 'selfie.jpg',
        ),
        'device_info': 'Android',
      });
      final response = await _apiService.post(
        '/presence/check-out',
        data: formData,
      );
      return PresenceResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("🔥 RESPONSE ERROR:");
      print(e.response?.data);
      throw _handleError(e);
    }
  }

  // 🔥 GET TODAY'S PRESENCE
  Future<PresenceResponse> getTodayPresence() async {
    try {
      final response = await _apiService.get('/presence/today');
      return PresenceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 🔥 IZIN
  Future<dynamic> izin({required String notes, String? attachmentPath}) async {
    try {
      FormData formData = FormData.fromMap({
        'notes': notes,
        if (attachmentPath != null)
          'attachment': await MultipartFile.fromFile(attachmentPath),
      });
      final response = await _apiService.post('/presence/izin', data: formData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 🔥 SAKIT
  Future<dynamic> sakit({required String notes, String? attachmentPath}) async {
    try {
      FormData formData = FormData.fromMap({
        'notes': notes,
        if (attachmentPath != null)
          'attachment': await MultipartFile.fromFile(attachmentPath),
      });
      final response = await _apiService.post(
        '/presence/sakit',
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 🔥 GET PRESENCE HISTORY
  Future<List<Presence>> getPresenceHistory({
    String? month,
    String? year,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (month != null) {
        queryParams['month'] = month;
      }
      if (year != null) {
        queryParams['year'] = year;
      }
      final response = await _apiService.get(
        '/presence/history',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final items = data['data']['items'] as List;
          return items.map((item) => Presence.fromJson(item)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 🔥 GET PRESENCE SUMMARY
  Future<Map<String, dynamic>> getPresenceSummary({
    String? month,
    String? year,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (month != null) queryParams['month'] = month;
      if (year != null) queryParams['year'] = year;

      final response = await _apiService.get(
        '/presence/summary',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data['data'] ?? {};
      }
      return {};
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
