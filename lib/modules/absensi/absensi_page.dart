import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/widgets/app_card.dart';
import '../auth/attendance_controller.dart';
import '../auth/dashboard_controller.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  final controller = Get.find<AttendanceController>();

  final dashboardController = Get.find<DashboardController>();

  String? fakeLocation;
  String? fakeImage;

  double? latitude;
  double? longitude;

  String? selectedImagePath;

  double scaleSubmit = 1.0;
  double scaleLocation = 1.0;
  double scalePhoto = 1.0;

  // 🔥 REAL GPS
  Future<void> getFakeLocation() async {
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

  // 🔥 REAL CAMERA
  Future<void> getFakePhoto() async {
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

  // 🔥 SUBMIT ABSENSI REALTIME
  void submitAbsensi() async {
    if (latitude == null || longitude == null) {
      Get.snackbar("Error", "Ambil lokasi dulu");

      return;
    }

    if (selectedImagePath == null) {
      Get.snackbar("Error", "Ambil foto dulu");

      return;
    }

    final success = await controller.checkIn(
      latitude: latitude!,
      longitude: longitude!,
      photoPath: selectedImagePath!,
    );

    if (success) {
      // 🔥 REFRESH DASHBOARD
      await dashboardController.loadTodayPresence();

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

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      Get.snackbar(
        "Error",
        controller.errorMessage.value ?? "Gagal melakukan absensi",

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
              // 🔹 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Absensi",

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

                            // 🔥 MAP LOCATION
                            Container(
                              height: 250,
                              width: double.infinity,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: latitude == null || longitude == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                      ),

                                      child: const Center(
                                        child: Text("Belum ada lokasi"),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),

                                      child: FlutterMap(
                                        options: MapOptions(
                                          initialCenter: LatLng(
                                            latitude!,
                                            longitude!,
                                          ),

                                          initialZoom: 18,
                                        ),

                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName:
                                                'com.example.absensi_guru',
                                          ),

                                          // 🔥 Radius sekolah
                                          CircleLayer(
                                            circles: [
                                              CircleMarker(
                                                point: LatLng(
                                                  -6.3948453,
                                                  106.8718339,
                                                ),

                                                radius: 200,

                                                useRadiusInMeter: true,

                                                color: Colors.blue.withOpacity(
                                                  0.2,
                                                ),

                                                borderStrokeWidth: 2,

                                                borderColor: Colors.blue,
                                              ),
                                            ],
                                          ),

                                          // 🔥 Marker user
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

                            Text(
                              fakeLocation ?? "Lokasi belum tersedia",

                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),

                            const SizedBox(height: 15),

                            GestureDetector(
                              onTapDown: (_) =>
                                  setState(() => scaleLocation = 0.97),

                              onTapUp: (_) async {
                                setState(() => scaleLocation = 1.0);

                                await getFakeLocation();
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

                                      children: const [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                        ),

                                        SizedBox(width: 10),

                                        Text(
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
                              constraints: BoxConstraints(
                                minHeight: 150,
                                maxHeight: 400,
                              ),

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

                                        fit: BoxFit.contain,
                                      ),
                                    ),
                            ),

                            const SizedBox(height: 15),

                            GestureDetector(
                              onTapDown: (_) =>
                                  setState(() => scalePhoto = 0.97),

                              onTapUp: (_) async {
                                setState(() => scalePhoto = 1.0);

                                await getFakePhoto();
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

                                      children: const [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.blue,
                                        ),

                                        SizedBox(width: 10),

                                        Text(
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
                              submitAbsensi();
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

                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.blue,
                                              ),
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.fingerprint,

                                        color: Colors.blue,
                                      ),

                                    const SizedBox(width: 10),

                                    Text(
                                      controller.isLoading.value
                                          ? "Memproses..."
                                          : "Submit Absensi",

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
