import 'package:dio/dio.dart';

import '../models/assessment_model.dart';
import 'api_service.dart';

class AssessmentRepository {

  final ApiService _apiService =
      ApiService();

  Future<List<AssessmentModel>>
      getMyAssessments() async {

    try {

      final response =
          await _apiService.get(
        '/assessments/me',
      );

      final items =
          response.data['data']['items']
              as List;

      return items
          .map(
            (e) => AssessmentModel
                .fromJson(e),
          )
          .toList();

    } on DioException catch (e) {

      throw Exception(
        e.response?.data['message'] ??
            'Gagal mengambil penilaian',
      );
    }
  }
}
