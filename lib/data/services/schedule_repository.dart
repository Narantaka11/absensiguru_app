import '../models/schedule_model.dart';
import 'api_service.dart';

class ScheduleRepository {
  Future<List<ScheduleModel>> getSchedules() async {
    final response = await ApiService().dio.get('/schedules');

    final schedules = response.data['data']['schedules'] as List;

    return schedules.map((e) => ScheduleModel.fromJson(e)).toList();
  }
}
