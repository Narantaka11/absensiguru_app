class ScheduleModel {
  final int id;

  final int dayOfWeek;

  final String startTime;

  final String endTime;

  final String subject;

  final String className;

  ScheduleModel({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.className,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],

      dayOfWeek: json['day_of_week'],

      startTime: json['start_time'] ?? '',

      endTime: json['end_time'] ?? '',

      subject: json['subject'] ?? '',

      className: json['class_name'] ?? '',
    );
  }

  String get dayName {
    switch (dayOfWeek) {
      case 1:
        return 'Senin';

      case 2:
        return 'Selasa';

      case 3:
        return 'Rabu';

      case 4:
        return 'Kamis';

      case 5:
        return 'Jumat';

      case 6:
        return 'Sabtu';

      case 7:
        return 'Minggu';

      default:
        return '-';
    }
  }
}
