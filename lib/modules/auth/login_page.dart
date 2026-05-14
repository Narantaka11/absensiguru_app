import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_card.dart';
import '../dashboard/dashboard_page.dart';
import 'attendance_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final controller = Get.find<AttendanceController>();

  double scale = 1.0;

  // 🔥 HANDLE LOGIN
  Future<void> _handleLogin() async {
    // 🔥 VALIDASI
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 🔥 CALL API
    final success = await controller.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (success) {
      Get.snackbar(
        'Berhasil',
        'Login berhasil! Selamat datang ${controller.currentUser.value?.name}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      // 🔥 NAVIGATE KE DASHBOARD
      Future.delayed(Duration(milliseconds: 500), () {
        Get.offAll(() => DashboardPage());
      });
    } else {
      Get.snackbar(
        'Login Gagal',
        controller.errorMessage.value ?? 'Terjadi kesalahan saat login',
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // 🔥 HERO SECTION
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.school, size: 50, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      "Absensi Guru",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Kelola kehadiran dengan mudah & cepat",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // 🔹 FORM
              AppCard(
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 🔥 LOGIN BUTTON
              Obx(
                () => GestureDetector(
                  onTapDown: (_) => setState(() => scale = 0.97),
                  onTapUp: (_) {
                    setState(() => scale = 1.0);
                    _handleLogin();
                  },
                  onTapCancel: () => setState(() => scale = 1.0),
                  child: AnimatedScale(
                    scale: scale,
                    duration: Duration(milliseconds: 150),
                    child: AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.isLoading.value)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                            )
                          else
                            Icon(Icons.login, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            controller.isLoading.value
                                ? "Memproses..."
                                : "Masuk",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // 🔥 INFO PENGGUNAAN (UPGRADED)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Cara Menggunakan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    infoItem(Icons.login, "Login dengan akun guru"),
                    infoItem(Icons.fingerprint, "Lakukan absensi setiap hari"),
                    infoItem(Icons.location_on, "Pastikan lokasi sesuai"),
                    infoItem(Icons.history, "Cek riwayat kehadiran"),
                  ],
                ),
              ),

              Spacer(),

              // 🔥 FOOTER
              Text(
                "© 2026 Sistem Absensi Guru",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 HELPER ITEM
  Widget infoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: Colors.blue),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
