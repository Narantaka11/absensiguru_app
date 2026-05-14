import 'package:get/get.dart';

import '../../data/services/presence_repository.dart';

class DashboardController extends GetxController {
  // 🔥 BOTTOM NAVIGATION INDEX
  var index = 0.obs;

  // 🔥 STATUS ABSENSI
  bool isCheckedIn = false;
  bool isCheckedOut = false;

  String attendanceStatus = 'Belum Absen';

  // 🔥 REPOSITORY
  final PresenceRepository _presenceRepository = PresenceRepository();

  // 🔥 LOAD SAAT DASHBOARD DIBUKA
  @override
  void onInit() {
    super.onInit();

    loadTodayPresence();
  }

  // 🔥 CHANGE TAB
  void changeTab(int i) {
    index.value = i;
  }

  // 🔥 LOAD ABSENSI HARI INI REALTIME
  Future<void> loadTodayPresence() async {
    try {
      final response = await _presenceRepository.getTodayPresence();

      print('🔥 TODAY PRESENCE RESPONSE');
      print(response);

      // 🔥 RESET DEFAULT
      isCheckedIn = false;
      isCheckedOut = false;

      attendanceStatus = 'Belum Absen';

      // 🔥 JIKA ADA DATA ABSENSI
      if (response.data != null) {
        final status = response.data!.status.toLowerCase();

        // 🔥 STATUS HADIR
        switch (status) {
          // 🔥 HADIR
          case 'hadir':
            isCheckedIn = true;

            attendanceStatus = 'Sudah Absen';

            break;

          // 🔥 TERLAMBAT
          case 'terlambat':
            isCheckedIn = true;

            attendanceStatus = 'Terlambat';

            break;

          // 🔥 IZIN
          case 'izin':
            attendanceStatus = 'Izin';

            break;

          // 🔥 SAKIT
          case 'sakit':
            attendanceStatus = 'Sakit';

            break;

          // 🔥 ALPA
          case 'alpa':
            attendanceStatus = 'Alpa';

            break;

          // 🔥 DEFAULT
          default:
            attendanceStatus = 'Belum Absen';
        }

        // 🔥 SUDAH CHECKOUT
        if (response.hasCheckedOut == true) {
          isCheckedOut = true;

          attendanceStatus = 'Sudah Pulang';
        }
      }

      update();
    } catch (e) {
      print('❌ LOAD TODAY PRESENCE ERROR');

      print(e);

      // 🔥 RESET JIKA ERROR
      isCheckedIn = false;
      isCheckedOut = false;

      attendanceStatus = 'Belum Absen';

      update();
    }
  }
}
