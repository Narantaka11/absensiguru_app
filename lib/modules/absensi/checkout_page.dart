import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

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

    setState(() {});
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
        "Berhasil",
        "Check-out berhasil dicatat",

        backgroundColor: Colors.green,

        colorText: Colors.white,
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
                              height: 250,

                              width: double.infinity,

                              decoration: BoxDecoration(
                                color: Colors.grey[200],

                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: latitude == null
                                  ? const Center(
                                      child: Text("Belum ada lokasi"),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),

                                      child: FlutterMap(
                                        options: MapOptions(
                                          initialCenter: LatLng(
                                            latitude!,
                                            longitude!,
                                          ),

                                          initialZoom: 16,
                                        ),

                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                                            userAgentPackageName:
                                                'com.example.absensi_guru',
                                          ),

                                          CircleLayer(
                                            circles: [
                                              CircleMarker(
                                                point: LatLng(
                                                  latitude!,
                                                  longitude!,
                                                ),

                                                radius: 100,

                                                color: Colors.blue.withValues(
                                                  alpha: 0.2,
                                                ),

                                                borderStrokeWidth: 2,

                                                borderColor: Colors.blue,
                                              ),
                                            ],
                                          ),

                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: LatLng(
                                                  latitude!,
                                                  longitude!,
                                                ),

                                                width: 80,

                                                height: 80,

                                                child: Column(
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on,

                                                      color: Colors.red,

                                                      size: 40,
                                                    ),

                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),

                                                      decoration: BoxDecoration(
                                                        color: Colors.white,

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),

                                                      child: const Text(
                                                        "Lokasi Anda",

                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                            ),

                            const SizedBox(height: 10),

                            if (latitude != null)
                              Align(
                                alignment: Alignment.centerLeft,

                                child: Text("Lat: $latitude\nLng: $longitude"),
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
                              height: 250,

                              width: double.infinity,

                              decoration: BoxDecoration(
                                color: Colors.grey[200],

                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: fakeImage == null
                                  ? const Center(child: Text("Belum ada foto"))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),

                                      child: Image.file(
                                        File(fakeImage!),

                                        fit: BoxFit.cover,

                                        width: double.infinity,
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
