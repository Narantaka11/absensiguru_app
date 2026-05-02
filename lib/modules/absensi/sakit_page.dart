import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_card.dart';
import '../auth/attendance_controller.dart';

class SakitPage extends StatefulWidget {
  const SakitPage({super.key});

  @override
  State<SakitPage> createState() => _SakitPageState();
}

class _SakitPageState extends State<SakitPage> {
  final controller = Get.find<AttendanceController>();

  final TextEditingController alasanController = TextEditingController();

  String? fakeImage;

  double scaleSubmit = 1.0;
  double scalePhoto = 1.0;

  void getFakePhoto() {
    setState(() {
      fakeImage = "https://picsum.photos/400";
    });
  }

  void submitSakit() {
    if (alasanController.text.isEmpty) {
      Get.snackbar("Error", "Isi keterangan sakit");
      return;
    }

    controller.markAttendance(
      controller.getCurrentDate(),
      "sakit",
    );

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
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.local_hospital, color: Colors.red),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Data Terkirim",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 4),
                  Text("Laporan sakit berhasil dikirim",
                      style: TextStyle(color: Colors.grey[600])),
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
                  Text("Sakit",
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

                      // 🔥 FORM KETERANGAN
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Keterangan Sakit",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            TextField(
                              controller: alasanController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "Masukkan keterangan sakit...",
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔥 FOTO (BUKTI)
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Upload Bukti (Opsional)",
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

                            SizedBox(height: 15),

                            // 🔥 BUTTON FOTO (STYLE SAMA)
                            GestureDetector(
                              onTapDown: (_) =>
                                  setState(() => scalePhoto = 0.97),
                              onTapUp: (_) {
                                setState(() => scalePhoto = 1.0);
                                getFakePhoto();
                              },
                              onTapCancel: () =>
                                  setState(() => scalePhoto = 1.0),
                              child: AnimatedScale(
                                scale: scalePhoto,
                                duration: Duration(milliseconds: 150),
                                child: AppCard(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt,
                                            color: Colors.red),
                                        SizedBox(width: 10),
                                        Text("Ambil Foto",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      // 🔥 SUBMIT
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() => scaleSubmit = 0.97);
                        },
                        onTapUp: (_) {
                          setState(() => scaleSubmit = 1.0);
                          submitSakit();
                        },
                        onTapCancel: () {
                          setState(() => scaleSubmit = 1.0);
                        },
                        child: AnimatedScale(
                          scale: scaleSubmit,
                          duration: Duration(milliseconds: 150),
                          child: AppCard(
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_hospital,
                                      color: Colors.red),
                                  SizedBox(width: 10),
                                  Text(
                                    "Kirim Laporan Sakit",
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
