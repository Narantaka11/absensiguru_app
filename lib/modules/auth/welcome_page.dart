import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Absensi Mudah",
      "desc": "Lakukan absensi hanya dalam satu langkah cepat",
    },
    {
      "title": "Validasi Lokasi & Foto",
      "desc": "Pastikan kehadiran sesuai lokasi sekolah",
    },
    {
      "title": "Riwayat & Laporan",
      "desc": "Pantau kehadiran dan keterlambatan dengan mudah",
    },
  ];

  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // 🔹 SLIDER
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final item = pages[index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🔥 ICON
                        Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mobile_friendly,
                            size: 60,
                            color: Colors.blue,
                          ),
                        ),

                        SizedBox(height: 30),

                        // 🔥 TITLE
                        Text(
                          item["title"]!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 10),

                        // 🔥 DESC
                        Text(
                          item["desc"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 🔹 DOT INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => Container(
                    margin: EdgeInsets.all(4),
                    width: currentIndex == index ? 12 : 8,
                    height: currentIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.blue
                          : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // 🔥 BUTTON (HANYA DI HALAMAN TERAKHIR)
              if (currentIndex == pages.length - 1)
                GestureDetector(
                  onTapDown: (_) => setState(() => scale = 0.97),
                  onTapUp: (_) {
                    setState(() => scale = 1.0);
                    Get.offAll(() => LoginPage());
                  },
                  onTapCancel: () => setState(() => scale = 1.0),
                  child: AnimatedScale(
                    scale: scale,
                    duration: Duration(milliseconds: 150),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 10),

              // 🔹 OPTIONAL SKIP
              if (currentIndex != pages.length - 1)
                TextButton(
                  onPressed: () {
                    controller.jumpToPage(pages.length - 1);
                  },
                  child: Text("Lewati"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
