import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_card.dart';
import '../auth/attendance_controller.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({super.key});

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  final controller = Get.find<AttendanceController>();

  final TextEditingController alasanController = TextEditingController();

  double scaleSubmit = 1.0;

  void submitIzin() {
    if (alasanController.text.isEmpty) {
      Get.snackbar("Error", "Isi alasan dulu");
      return;
    }

    controller.markAttendance(
      controller.getCurrentDate(),
      "izin",
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
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.assignment, color: Colors.orange),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Izin Terkirim",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 4),
                  Text("Data izin berhasil dikirim",
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
                  Text("Izin",
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
                child: Column(
                  children: [

                    // 🔥 FORM ALASAN
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Alasan Izin",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextField(
                            controller: alasanController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Masukkan alasan izin...",
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    // 🔥 SUBMIT BUTTON (SAMA STYLE)
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() => scaleSubmit = 0.97);
                      },
                      onTapUp: (_) {
                        setState(() => scaleSubmit = 1.0);
                        submitIzin();
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
                                Icon(Icons.assignment,
                                    color: Colors.orange),
                                SizedBox(width: 10),
                                Text(
                                  "Kirim Izin",
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
            ],
          ),
        ),
      ),
    );
  }
}
