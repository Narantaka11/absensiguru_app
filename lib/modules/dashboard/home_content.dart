import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../core/widgets/app_card.dart';
import '../absensi/absensi_page.dart';
import '../auth/attendance_controller.dart';
import '../auth/dashboard_controller.dart';
import '../absensi/izin_page.dart';
import '../absensi/sakit_page.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  double scale = 1.0;
  int currentBanner = 0;

  final controller = Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> banners = [
      {
        "image": "https://picsum.photos/400/200?1",
        "title": "Rapat Guru",
        "desc": "Hari ini jam 10:00 di ruang meeting"
      },
      {
        "image": "https://picsum.photos/400/200?2",
        "title": "Pengumpulan Nilai",
        "desc": "Deadline hari Jumat"
      },
      {
        "image": "https://picsum.photos/400/200?3",
        "title": "Libur Nasional",
        "desc": "Tanggal 17 Agustus"
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dashboard",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    final c = Get.find<DashboardController>();
                    c.changeTab(3);
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // 🔥 STATUS HARI INI
            Obx(() {
              final status = controller.getTodayStatus();

              String text;
              Color color;
              IconData icon;

              switch (status) {
                case "hadir":
                  text = "Sudah Absen";
                  color = Colors.green;
                  icon = Icons.check_circle;
                  break;
                case "telat":
                  text = "Terlambat";
                  color = Colors.orange;
                  icon = Icons.warning;
                  break;
                default:
                  text = "Belum Absen";
                  color = Colors.red;
                  icon = Icons.close;
              }

              return AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status Hari Ini"),
                        SizedBox(height: 5),
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color),
                        ),
                      ],
                    ),
                    Icon(icon, color: color)
                  ],
                ),
              );
            }),

            SizedBox(height: 20),

            Text("Menu",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

            SizedBox(height: 20),

            // 🔥 ABSEN BUTTON (UPDATED)
            GestureDetector(
              onTapDown: (_) => setState(() => scale = 0.97),
              onTapUp: (_) {
                setState(() => scale = 1.0);

                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text("Pilih Absensi",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold)),

                          SizedBox(height: 20),

                          actionButton(
                              "Hadir",
                              Icons.check_circle,
                              Colors.green, () {
                            Get.back();
                            Get.to(() => AbsensiPage());
                          }),

                          actionButton(
                              "Izin",
                              Icons.assignment,
                              Colors.orange, () {
                            Get.back();
                            Get.to(() => IzinPage());
                          }),

                          actionButton(
                              "Sakit",
                              Icons.local_hospital,
                              Colors.red, () {
                            Get.back();
                            Get.to(() => SakitPage());
                          }),
                        ],
                      ),
                    );
                  },
                );
              },
              onTapCancel: () => setState(() => scale = 1.0),
              child: AnimatedScale(
                scale: scale,
                duration: Duration(milliseconds: 150),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.fingerprint,
                            size: 30, color: Colors.blue),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Absen Sekarang",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            SizedBox(height: 5),
                            Text(
                                "Tekan untuk melakukan absensi hari ini",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 25),

            Text("Informasi",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

            SizedBox(height: 10),

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
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
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
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(item["title"]!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold)),
                            Text(item["desc"]!,
                                style:
                                    TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
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
    );
  }

  // 🔥 BUTTON HELPER
  Widget actionButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
