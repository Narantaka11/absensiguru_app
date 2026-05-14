import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/app_card.dart';
import '../../data/services/presence_repository.dart';
import '../auth/attendance_controller.dart';
import '../auth/dashboard_controller.dart';

class SakitPage extends StatefulWidget {
  const SakitPage({super.key});

  @override
  State<SakitPage> createState() => _SakitPageState();
}

class _SakitPageState extends State<SakitPage> {
  final controller = Get.find<AttendanceController>();

  final dashboardController = Get.find<DashboardController>();

  final PresenceRepository repository = PresenceRepository();

  final TextEditingController alasanController = TextEditingController();

  File? imageFile;

  double scaleSubmit = 1.0;
  double scalePhoto = 1.0;

  bool isLoading = false;

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

  // 🔥 SUBMIT SAKIT
  Future<void> submitSakit() async {
    if (alasanController.text.isEmpty) {
      Get.snackbar("Error", "Isi keterangan sakit");

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // 🔥 HIT API LARAVEL
      await repository.sakit(
        notes: alasanController.text,
        attachmentPath: imageFile?.path,
      );

      // 🔥 UPDATE DASHBOARD REALTIME
      await dashboardController.loadTodayPresence();

      // 🔥 UPDATE LOCAL STATE
      controller.markAttendance(controller.getCurrentDate(), "sakit");

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
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),

                child: const Icon(Icons.local_hospital, color: Colors.red),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Data Terkirim",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Laporan sakit berhasil dikirim",

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
                    "Sakit",

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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 🔥 FORM KETERANGAN
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Keterangan Sakit",

                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 10),

                            TextField(
                              controller: alasanController,
                              maxLines: 4,

                              decoration: const InputDecoration(
                                hintText: "Masukkan keterangan sakit...",
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔥 FOTO BUKTI
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Upload Bukti (Opsional)",

                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              height: 180,
                              width: double.infinity,

                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: imageFile == null
                                  ? const Center(child: Text("Belum ada foto"))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),

                                      child: Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),

                            const SizedBox(height: 15),

                            // 🔥 BUTTON FOTO
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  scalePhoto = 0.97;
                                });
                              },

                              onTapUp: (_) {
                                setState(() {
                                  scalePhoto = 1.0;
                                });

                                pickImage();
                              },

                              onTapCancel: () {
                                setState(() {
                                  scalePhoto = 1.0;
                                });
                              },

                              child: AnimatedScale(
                                scale: scalePhoto,

                                duration: const Duration(milliseconds: 150),

                                child: AppCard(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        const Icon(
                                          Icons.camera_alt,
                                          color: Colors.red,
                                        ),

                                        const SizedBox(width: 10),

                                        Text(
                                          imageFile == null
                                              ? "Ambil Foto"
                                              : "Foto Terupload",

                                          style: const TextStyle(
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

                      const SizedBox(height: 30),

                      // 🔥 SUBMIT
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
                            submitSakit();
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        const Icon(
                                          Icons.local_hospital,
                                          color: Colors.red,
                                        ),

                                        const SizedBox(width: 10),

                                        const Text(
                                          "Kirim Laporan Sakit",

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
