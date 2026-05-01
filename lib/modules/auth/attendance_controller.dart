import 'package:get/get.dart';

class AttendanceController extends GetxController {
  var attendanceData = <DateTime, String>{}.obs;

  void markAttendance(DateTime date, String status) {
    attendanceData[DateTime.utc(date.year, date.month, date.day)] = status;
    attendanceData.refresh();
  }
}
