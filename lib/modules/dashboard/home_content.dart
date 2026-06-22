import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../core/widgets/app_card.dart';

import '../absensi/absensi_page.dart';
import '../absensi/checkout_page.dart';
import '../absensi/izin_page.dart';
import '../absensi/sakit_page.dart';

import '../auth/attendance_controller.dart';
import '../auth/dashboard_controller.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  double scale = 1.0;

  int currentBanner = 0;

  final attendanceController = Get.find<AttendanceController>();

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> banners = [
      {
        "image": "assets/images/banner2.jpg",
        "title": "Rapat Guru",
        "desc": "Hari ini jam 10:00 di Ruang Meeting",
      },

      {
        "image": "assets/images/banner2.jpg",
        "title": "Pengumpulan Nilai",
        "desc": "Deadline Hari Jumat",
      },

      {
        "image": "assets/images/banner2.jpg",
        "title": "Libur Nasional",
        "desc": "Tanggal 17 Agustus",
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // 🔥 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Dashboard",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  GestureDetector(
                    onTap: () {
                      dashboardController.changeTab(3);
                    },

                    child: const CircleAvatar(child: Icon(Icons.person)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔥 STATUS HARI INI
              GetBuilder<DashboardController>(
                builder: (controller) {
                  Color statusColor = controller.isCheckedIn
                      ? Colors.green
                      : Colors.red;

                  IconData statusIcon = controller.isCheckedIn
                      ? Icons.check_circle
                      : Icons.close;

                  return AppCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text("Status Hari Ini"),

                            const SizedBox(height: 5),

                            Text(
                              controller.attendanceStatus,

                              style: TextStyle(
                                fontSize: 18,

                                fontWeight: FontWeight.bold,

                                color: statusColor,
                              ),
                            ),
                          ],
                        ),

                        Icon(statusIcon, color: statusColor, size: 30),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Menu",

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 20),

              // 🔥 ABSEN BUTTON
              GestureDetector(
                onTapDown: (_) => setState(() => scale = 0.97),

                onTapUp: (_) {
                  setState(() => scale = 1.0);

                  showModalBottomSheet(
                    context: context,

                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),

                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            const Text(
                              "Pilih Absensi",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 🔥 JIKA SUDAH ABSEN → CHECKOUT
                            GetBuilder<DashboardController>(
                              builder: (controller) {
                                // 🔥 BELUM ABSEN
                                if (!controller.isCheckedIn) {
                                  return actionButton(
                                    "Hadir",

                                    Icons.check_circle,

                                    Colors.green,

                                    () {
                                      Get.back();

                                      Get.to(() => const AbsensiPage());
                                    },
                                  );
                                }

                                // 🔥 SUDAH ABSEN TAPI BELUM PULANG
                                if (controller.isCheckedIn &&
                                    !controller.isCheckedOut) {
                                  return actionButton(
                                    "Check-Out",

                                    Icons.logout,

                                    Colors.blue,

                                    () {
                                      Get.back();

                                      Get.to(() => const CheckOutPage());
                                    },
                                  );
                                }

                                // 🔥 SUDAH PULANG
                                return actionButton(
                                  "Sudah Pulang",

                                  Icons.check,

                                  Colors.grey,

                                  () {},
                                );
                              },
                            ),

                            // 🔥 IZIN
                            actionButton(
                              "Izin",

                              Icons.assignment,

                              Colors.orange,

                              () {
                                Get.back();

                                Get.to(() => IzinPage());
                              },
                            ),

                            // 🔥 SAKIT
                            actionButton(
                              "Sakit",

                              Icons.local_hospital,

                              Colors.red,

                              () {
                                Get.back();

                                Get.to(() => SakitPage());
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },

                onTapCancel: () => setState(() => scale = 1.0),

                child: AnimatedScale(
                  scale: scale,

                  duration: const Duration(milliseconds: 150),

                  child: AppCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),

                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: const Icon(
                            Icons.fingerprint,

                            size: 30,

                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              GetBuilder<DashboardController>(
                                builder: (controller) {
                                  String title = "Absen Sekarang";

                                  if (controller.isCheckedIn &&
                                      !controller.isCheckedOut) {
                                    title = "Check-Out";
                                  }

                                  if (controller.isCheckedOut) {
                                    title = "Sudah Pulang";
                                  }

                                  return Text(
                                    title,

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 16,
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                "Tekan untuk melakukan absensi hari ini",

                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Informasi",

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 10),

              // 🔥 BANNER
              CarouselSlider(
                options: CarouselOptions(
                  height: 170,

                  autoPlay: true,

                  enlargeCenterPage: true,

                  viewportFraction: 0.85,

                  onPageChanged: (index, reason) {
                    setState(() {
                      currentBanner = index;
                    });
                  },
                ),

                items: banners.map((item) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),

                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: Image.asset(
                            item["image"]!,

                            width: double.infinity,

                            fit: BoxFit.cover,
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),

                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),

                        Positioned(
                          bottom: 15,

                          left: 15,

                          right: 15,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                item["title"]!,

                                style: const TextStyle(
                                  color: Colors.white,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                item["desc"]!,

                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              // 🔥 INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: List.generate(
                  banners.length,

                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),

                    margin: const EdgeInsets.symmetric(horizontal: 4),

                    width: currentBanner == index ? 12 : 8,

                    height: currentBanner == index ? 12 : 8,

                    decoration: BoxDecoration(
                      color: currentBanner == index
                          ? Colors.blue
                          : Colors.grey[300],

                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 BUTTON HELPER
  Widget actionButton(
    String title,

    IconData icon,

    Color color,

    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: color.withOpacity(0.1),

          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [
            Icon(icon, color: color),

            const SizedBox(width: 10),

            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
