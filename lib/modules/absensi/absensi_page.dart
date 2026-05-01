import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // 🔹 DUMMY GPS
  void getFakeLocation() {
    setState(() {
      fakeLocation = "Lat: -6.2000\nLng: 106.8166"; // Jakarta contoh
    });
  }

  // 🔹 DUMMY FOTO
  void getFakePhoto() {
    setState(() {
      fakeImage = "https://picsum.photos/300";
    });
  }

  // 🔹 LOGIC STATUS
  String getStatus(DateTime now) {
    final jamMasuk = DateTime(now.year, now.month, now.day, 7, 0);

    if (now.isBefore(jamMasuk) || now.isAtSameMomentAs(jamMasuk)) {
      return "hadir";
    } else {
      return "telat";
    }
  }

  // 🔹 SUBMIT
  void submitAbsensi() {
    if (fakeLocation == null) {
      Get.snackbar("Error", "Lokasi belum diambil");
      return;
    }

    if (fakeImage == null) {
      Get.snackbar("Error", "Foto belum diambil");
      return;
    }

    DateTime now = DateTime.now();
    String status = getStatus(now);

    controller.markAttendance(now, status);

    Get.snackbar(
      "Absensi Berhasil",
      "Status: $status",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Absensi")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔹 GPS BOX
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: fakeLocation == null
                    ? Text("Lokasi belum diambil")
                    : Text(fakeLocation!),
              ),
            ),

            SizedBox(height: 15),

            ElevatedButton(
              onPressed: getFakeLocation,
              child: Text("Ambil Lokasi"),
            ),

            SizedBox(height: 20),

            // 🔹 FOTO BOX
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: fakeImage == null
                  ? Center(child: Text("Belum ada foto"))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(fakeImage!,
                          fit: BoxFit.cover),
                    ),
            ),

            SizedBox(height: 15),

            ElevatedButton(
              onPressed: getFakePhoto,
              child: Text("Ambil Foto"),
            ),

            SizedBox(height: 30),

            // 🔥 SUBMIT
            ElevatedButton(
              onPressed: submitAbsensi,
              child: Text("Submit Absensi"),
            ),
          ],
        ),
      ),
    );
  }
}
