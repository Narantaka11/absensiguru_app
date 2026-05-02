import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_card.dart';
import '../auth/attendance_controller.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  final controller = Get.find<AttendanceController>();

  String? fakeLocation;
  String? fakeImage;

  double scale = 1.0;

  void getFakeLocation() {
    setState(() {
      fakeLocation = "Lat: -6.2000\nLng: 106.8166";
    });
  }

  void getFakePhoto() {
    setState(() {
      fakeImage = "https://picsum.photos/400";
    });
  }

  String getStatus(DateTime now) {
    final jamMasuk = DateTime(now.year, now.month, now.day, 7, 0);

    if (now.isBefore(jamMasuk) || now.isAtSameMomentAs(jamMasuk)) {
      return "hadir";
    } else {
      return "telat";
    }
  }

  void submitAbsensi() {
    if (fakeLocation == null) {
      Get.snackbar("Error", "Ambil lokasi dulu");
      return;
    }

    if (fakeImage == null) {
      Get.snackbar("Error", "Ambil foto dulu");
      return;
    }

    DateTime now = controller.getCurrentDate();
    String status = getStatus(now);

    controller.markAttendance(now, status);

    Get.snackbar(
      "",
      "",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.all(16),
      duration: Duration(seconds: 2),

      titleText: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [

            // ICON
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.green),
            ),

            SizedBox(width: 12),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Berhasil",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Absensi berhasil dicatat",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    Future.delayed(Duration(milliseconds: 2000), () {
      Get.back();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              // 🔹 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Absensi",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  )
                ],
              ),

              SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      // 🔥 LOKASI
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lokasi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: fakeLocation == null
                                    ? Text("Belum ada lokasi")
                                    : Text(fakeLocation!),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: getFakeLocation,
                              child: Text("Ambil Lokasi"),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔥 FOTO
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Foto Selfie",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: fakeImage == null
                                  ? Center(child: Text("Belum ada foto"))
                                  : ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      child: Image.network(
                                        fakeImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: getFakePhoto,
                              child: Text("Ambil Foto"),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      // 🔥 SUBMIT BUTTON (ANIMASI)
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() => scale = 0.97);
                        },
                        onTapUp: (_) {
                          setState(() => scale = 1.0);
                          submitAbsensi();
                        },
                        onTapCancel: () {
                          setState(() => scale = 1.0);
                        },
                        child: AnimatedScale(
                          scale: scale,
                          duration: Duration(milliseconds: 150),
                          child: AppCard(
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.fingerprint,
                                      color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text(
                                    "Submit Absensi",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
