import 'package:dio/dio.dart';

import '../models/salary_model.dart';
import 'api_service.dart';

class SalaryRepository {
  final ApiService _apiService = ApiService();

  Future<SalaryModel?> getMySalary() async {
    try {
      final response = await _apiService.get('/payroll/me');

      print(response.data);

      final data = response.data['data']['salary'];

      if (data == null) {
        return null;
      }

      return SalaryModel.fromJson(data);
    } on DioException catch (e) {
      print(e.response?.data);

      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil slip gaji',
      );
    }
  }
}
