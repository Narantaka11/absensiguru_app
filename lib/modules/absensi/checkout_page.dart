import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/dashboard_controller.dart';

import '../../../core/widgets/app_card.dart';
import '../auth/attendance_controller.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final controller = Get.find<AttendanceController>();

  String? fakeLocation;
  String? fakeImage;

  double? latitude;
  double? longitude;

  String? selectedImagePath;

  double scaleSubmit = 1.0;
  double scaleLocation = 1.0;
  double scalePhoto = 1.0;

  // 🔥 REAL GPS
  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Get.snackbar("Error", "GPS belum aktif");

      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Permission GPS ditolak");

      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;

    setState(() {
      fakeLocation = "Lat: ${position.latitude}\nLng: ${position.longitude}";
    });
  }

  // 🔥 CAMERA
  Future<void> getPhoto() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        fakeImage = pickedFile.path;

        selectedImagePath = pickedFile.path;
      });
    }
  }

  // 🔥 SUBMIT CHECKOUT
  void submitCheckOut() async {
    if (latitude == null || longitude == null) {
      Get.snackbar("Error", "Ambil lokasi dulu");

      return;
    }

    if (selectedImagePath == null) {
      Get.snackbar("Error", "Ambil foto dulu");

      return;
    }

    final success = await controller.checkOut(
      latitude: latitude!,
      longitude: longitude!,
      photoPath: selectedImagePath!,
    );

    if (success) {
      final dashboardController = Get.find<DashboardController>();

      dashboardController.isCheckedOut = true;

      dashboardController.attendanceStatus = "Sudah Pulang";

      dashboardController.update();

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
                  color: Colors.green.withOpacity(0.1),

                  shape: BoxShape.circle,
                ),

                child: const Icon(Icons.check, color: Colors.green),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Berhasil",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Check-out berhasil dicatat",

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
    } else {
      Get.snackbar(
        "Error",

        controller.errorMessage.value ?? "Gagal check-out",

        backgroundColor: Colors.red,

        colorText: Colors.white,
      );
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
                    "Check-Out",

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
                      // 🔥 LOKASI
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Lokasi",

                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              height: 100,

                              width: double.infinity,

                              decoration: BoxDecoration(
                                color: Colors.grey[200],

                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Center(
                                child: fakeLocation == null
                                    ? const Text("Belum ada lokasi")
                                    : Text(fakeLocation!),
                              ),
                            ),

                            const SizedBox(height: 15),

                            GestureDetector(
                              onTapDown: (_) =>
                                  setState(() => scaleLocation = 0.97),

                              onTapUp: (_) async {
                                setState(() => scaleLocation = 1.0);

                                await getLocation();
                              },

                              onTapCancel: () =>
                                  setState(() => scaleLocation = 1.0),

                              child: AnimatedScale(
                                scale: scaleLocation,

                                duration: const Duration(milliseconds: 150),

                                child: AppCard(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        const Icon(
                                          Icons.location_on,

                                          color: Colors.blue,
                                        ),

                                        const SizedBox(width: 10),

                                        const Text(
                                          "Ambil Lokasi",

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

                      const SizedBox(height: 20),

                      // 🔥 FOTO
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Foto Selfie",

                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              height: 150,

                              width: double.infinity,

                              decoration: BoxDecoration(
                                color: Colors.grey[200],

                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: fakeImage == null
                                  ? const Center(child: Text("Belum ada foto"))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),

                                      child: Image.file(
                                        File(fakeImage!),

                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),

                            const SizedBox(height: 15),

                            GestureDetector(
                              onTapDown: (_) =>
                                  setState(() => scalePhoto = 0.97),

                              onTapUp: (_) async {
                                setState(() => scalePhoto = 1.0);

                                await getPhoto();
                              },

                              onTapCancel: () =>
                                  setState(() => scalePhoto = 1.0),

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

                                          color: Colors.blue,
                                        ),

                                        const SizedBox(width: 10),

                                        const Text(
                                          "Ambil Foto",

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

                      const SizedBox(height: 30),

                      // 🔥 SUBMIT
                      Obx(
                        () => GestureDetector(
                          onTapDown: (_) {
                            setState(() => scaleSubmit = 0.97);
                          },

                          onTapUp: (_) {
                            setState(() => scaleSubmit = 1.0);

                            if (!controller.isLoading.value) {
                              submitCheckOut();
                            }
                          },

                          onTapCancel: () {
                            setState(() => scaleSubmit = 1.0);
                          },

                          child: AnimatedScale(
                            scale: scaleSubmit,

                            duration: const Duration(milliseconds: 150),

                            child: AppCard(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    if (controller.isLoading.value)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,

                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.logout,
                                        color: Colors.blue,
                                      ),

                                    const SizedBox(width: 10),

                                    Text(
                                      controller.isLoading.value
                                          ? "Memproses..."
                                          : "Submit Check-Out",

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
