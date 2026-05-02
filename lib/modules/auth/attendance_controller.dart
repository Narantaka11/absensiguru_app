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

  // 🔥 set tanggal manual
  void setDummyDate(DateTime date) {
    selectedDummyDate = date;
  }

  // 🔥 TAMBAH / UPDATE ABSENSI (ANTI DOUBLE)
  void markAttendance(DateTime date, String status) {
    // hapus dulu kalau sudah ada di tanggal itu
    attendanceList.removeWhere((item) =>
        item.dateTime.year == date.year &&
        item.dateTime.month == date.month &&
        item.dateTime.day == date.day);

    attendanceList.add(
      AttendanceModel(
        dateTime: date,
        status: status,
      ),
    );

    attendanceList.refresh();
  }

  // 🔥 STATUS HARI INI (FIXED)
  String getTodayStatus() {
    final today = getCurrentDate();

    final todayRecords = getByDate(today);

    if (todayRecords.isEmpty) return "belum";

    final status = todayRecords.first.status;

    return status;
  }

  // 🔥 AMBIL DATA PER TANGGAL
  List<AttendanceModel> getByDate(DateTime day) {
    return attendanceList.where((item) {
      return item.dateTime.year == day.year &&
          item.dateTime.month == day.month &&
          item.dateTime.day == day.day;
    }).toList();
  }

  // 🔥 AMBIL DATA PER BULAN
  List<AttendanceModel> getByMonth(DateTime month) {
    return attendanceList.where((item) {
      return item.dateTime.year == month.year &&
          item.dateTime.month == month.month;
    }).toList();
  }

  // 🔥 HELPER WARNA (UNTUK KALENDER)
  String getStatusByDate(DateTime date) {
    final data = getByDate(date);

    if (data.isEmpty) return "tidak";

    return data.first.status;
  }
}
