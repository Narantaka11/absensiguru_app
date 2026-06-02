import 'package:get/get.dart';

import '../../data/models/responses.dart';
import '../../data/models/assessment_model.dart';

import '../../data/services/auth_repository.dart';
import '../../data/services/presence_repository.dart';
import '../../data/services/assessment_repository.dart';

class AttendanceModel {
  final DateTime dateTime;
  final String status;

  AttendanceModel({required this.dateTime, required this.status});
}

class AttendanceController extends GetxController {
  var attendanceList = <AttendanceModel>[].obs;

  // 🔥 API REPOSITORIES
  final AuthRepository _authRepository = AuthRepository();

  final PresenceRepository _presenceRepository = PresenceRepository();

  final AssessmentRepository _assessmentRepository = AssessmentRepository();

  // 🔥 STATE MANAGEMENT
  var isLoading = false.obs;

  var currentUser = Rx<User?>(null);

  var errorMessage = Rx<String?>(null);

  // 🔥 ASSESSMENTS
  RxList<AssessmentModel> assessments = <AssessmentModel>[].obs;

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

  // 🔥 ON INIT
  @override
  void onInit() {
    super.onInit();

    getCurrentUserData();
    getAssessments();
  }

  // 🔥 LOGIN API
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      errorMessage.value = null;

      final response = await _authRepository.login(email, password);

      if (response.success && response.user != null) {
        currentUser.value = response.user;

        // 🔥 LOAD ASSESSMENTS
        await getAssessments();

        return true;
      } else {
        errorMessage.value = response.message;

        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 GET CURRENT USER
  Future<void> getCurrentUserData() async {
    try {
      isLoading.value = true;

      final result = await _authRepository.getCurrentUser();

      if (result != null) {
        currentUser.value = result;

        print(currentUser.value?.name);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 GET ASSESSMENTS
  Future<void> getAssessments() async {
    try {
      final result = await _assessmentRepository.getMyAssessments();

      assessments.value = result;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // 🔥 LOGOUT
  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _authRepository.logout();

      currentUser.value = null;

      attendanceList.clear();

      assessments.clear();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 CHECK-IN
  Future<bool> checkIn({
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    try {
      isLoading.value = true;

      errorMessage.value = null;

      final response = await _presenceRepository.checkIn(
        latitude: latitude,
        longitude: longitude,
        photoPath: photoPath,
      );

      if (response.success && response.data != null) {
        return true;
      } else {
        errorMessage.value = response.message;

        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 CHECK OUT
  Future<bool> checkOut({
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    try {
      isLoading.value = true;

      errorMessage.value = null;

      final response = await _presenceRepository.checkOut(
        latitude: latitude,
        longitude: longitude,
        photoPath: photoPath,
      );

      isLoading.value = false;

      if (response.success == true) {
        return true;
      } else {
        errorMessage.value = response.message ?? 'Check-out gagal';

        return false;
      }
    } catch (e) {
      isLoading.value = false;

      errorMessage.value = e.toString();

      return false;
    }
  }

  // 🔥 LOAD PRESENCE HISTORY
  Future<void> loadPresenceHistory({String? month, String? year}) async {
    try {
      isLoading.value = true;

      final presences = await _presenceRepository.getPresenceHistory(
        month: month,
        year: year,
      );

      attendanceList.clear();

      for (var presence in presences) {
        final date = DateTime.parse(presence.date);

        markAttendance(date, presence.status);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 TAMBAH / UPDATE ABSENSI
  void markAttendance(DateTime date, String status) {
    attendanceList.removeWhere(
      (item) =>
          item.dateTime.year == date.year &&
          item.dateTime.month == date.month &&
          item.dateTime.day == date.day,
    );

    attendanceList.add(AttendanceModel(dateTime: date, status: status));

    attendanceList.refresh();
  }

  // 🔥 STATUS HARI INI
  String getTodayStatus() {
    final today = getCurrentDate();

    final todayRecords = getByDate(today);

    if (todayRecords.isEmpty) {
      return "belum";
    }

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

  // 🔥 HELPER WARNA
  String getStatusByDate(DateTime date) {
    final data = getByDate(date);

    if (data.isEmpty) {
      return "tidak";
    }

    return data.first.status;
  }
}
