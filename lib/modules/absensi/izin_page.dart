import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/app_card.dart';
import '../../data/services/presence_repository.dart';
import '../auth/attendance_controller.dart';
import '../auth/dashboard_controller.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({super.key});

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  final attendanceController = Get.find<AttendanceController>();

  final dashboardController = Get.find<DashboardController>();

  final PresenceRepository repository = PresenceRepository();

  final TextEditingController alasanController = TextEditingController();

  double scaleSubmit = 1.0;

  bool isLoading = false;

  File? imageFile;

  // 🔥 PICK IMAGE
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // 🔥 SUBMIT IZIN
  Future<void> submitIzin() async {
    if (alasanController.text.isEmpty) {
      Get.snackbar("Error", "Isi alasan dulu");

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // 🔥 HIT API LARAVEL
      await repository.izin(
        notes: alasanController.text,
        attachmentPath: imageFile?.path,
      );

      // 🔥 UPDATE DASHBOARD REALTIME
      await dashboardController.loadTodayPresence();

      // 🔥 UPDATE LOCAL STATE
      attendanceController.markAttendance(
        attendanceController.getCurrentDate(),
        "izin",
      );

      Get.snackbar(
        "",
        "",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),

        titleText: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),

                child: const Icon(Icons.assignment, color: Colors.orange),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Izin Terkirim",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Data izin berhasil dikirim",

                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // 🔥 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Izin",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Column(
                  children: [
                    // 🔥 FORM ALASAN
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Alasan Izin",

                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            controller: alasanController,
                            maxLines: 4,

                            decoration: const InputDecoration(
                              hintText: "Masukkan alasan izin...",
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 UPLOAD BUKTI
                    GestureDetector(
                      onTap: pickImage,

                      child: AppCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Icon(Icons.camera_alt, color: Colors.orange),

                            const SizedBox(width: 10),

                            Text(
                              imageFile == null
                                  ? "Upload Bukti"
                                  : "Bukti Terupload",

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 PREVIEW IMAGE
                    if (imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),

                        child: Image.file(
                          imageFile!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    const Spacer(),

                    // 🔥 SUBMIT BUTTON
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          scaleSubmit = 0.97;
                        });
                      },

                      onTapUp: (_) {
                        setState(() {
                          scaleSubmit = 1.0;
                        });

                        if (!isLoading) {
                          submitIzin();
                        }
                      },

                      onTapCancel: () {
                        setState(() {
                          scaleSubmit = 1.0;
                        });
                      },

                      child: AnimatedScale(
                        scale: scaleSubmit,

                        duration: const Duration(milliseconds: 150),

                        child: AppCard(
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      const Icon(
                                        Icons.assignment,
                                        color: Colors.orange,
                                      ),

                                      const SizedBox(width: 10),

                                      const Text(
                                        "Kirim Izin",

                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
