import 'package:get/get.dart';

class AttendanceModel {
  final DateTime dateTime;
  final String status;

  AttendanceModel({
    required this.dateTime,
    required this.status,
  });
}

class AttendanceController extends GetxController {
  var attendanceList = <AttendanceModel>[].obs;

  // 🔥 DUMMY DATE (UNTUK TEST)
  DateTime? selectedDummyDate;

  // 🔥 ambil tanggal aktif
  DateTime getCurrentDate() {
  return selectedDummyDate ?? DateTime.now();
  }

  // 🔥 set tanggal manual dari kalender
  void setDummyDate(DateTime date) {
  selectedDummyDate = date;
  }

  void markAttendance(DateTime date, String status) {
    attendanceList.add(
      AttendanceModel(
        dateTime: date,
        status: status,
      ),
    );

    attendanceList.refresh();
  }

  String getTodayStatus() {
    final today = DateTime.now();
    final todayRecords = getByMonth(today);

    if (todayRecords.isEmpty) {
      return "belum";
    }

    if (todayRecords.any((item) => item.status == "hadir")) {
      return "hadir";
    }

    if (todayRecords.any((item) => item.status == "telat")) {
      return "telat";
    }

    return todayRecords.first.status;
  }

  List<AttendanceModel> getByDate(DateTime day) {
    return attendanceList.where((item) {
      return item.dateTime.year == day.year &&
          item.dateTime.month == day.month &&
          item.dateTime.day == day.day;
    }).toList();
  }

  List<AttendanceModel> getByMonth(DateTime month) {
    return attendanceList.where((item) {
      return item.dateTime.year == month.year &&
          item.dateTime.month == month.month;
    }).toList();
  }
}
