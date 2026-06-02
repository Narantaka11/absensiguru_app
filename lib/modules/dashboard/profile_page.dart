import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_card.dart';

import '../auth/attendance_controller.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final attendanceController = Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        final user = attendanceController.currentUser.value;

        if (attendanceController.isLoading.value && user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await attendanceController.getCurrentUserData();

            await attendanceController.getAssessments();
          },

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

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
                        "Profile",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(12),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),

                              blurRadius: 10,
                            ),
                          ],
                        ),

                        child: const Icon(Icons.settings),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // 🔥 PROFILE CARD
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade700],
                      ),

                      borderRadius: BorderRadius.circular(24),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),

                          blurRadius: 20,

                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        // 🔥 AVATAR
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 45,

                              backgroundColor: Colors.white,

                              backgroundImage: user?.profileImage != null
                                  ? NetworkImage(user!.profileImage!)
                                  : null,

                              child: user?.profileImage == null
                                  ? const Icon(
                                      Icons.person,

                                      size: 50,

                                      color: Colors.blue,
                                    )
                                  : null,
                            ),

                            Positioned(
                              right: 0,
                              bottom: 0,

                              child: Container(
                                padding: const EdgeInsets.all(6),

                                decoration: BoxDecoration(
                                  color: Colors.green,

                                  shape: BoxShape.circle,

                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // 🔥 NAME
                        Text(
                          user?.name ?? "-",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),

                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 5),

                        // 🔥 ROLE
                        Text(
                          user?.role ?? "Guru",

                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔥 DETAIL INFO
                  AppCard(
                    child: Column(
                      children: [
                        profileItem(Icons.email, "Email", user?.email ?? "-"),

                        profileItem(Icons.badge, "Role", user?.role ?? "-"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔥 TITLE
                  const Text(
                    "Riwayat Penilaian",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  // 🔥 ASSESSMENT LIST
                  Obx(() {
                    final assessments = attendanceController.assessments;

                    if (assessments.isEmpty) {
                      return Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Center(child: Text("Belum ada penilaian")),
                      );
                    }

                    return Column(
                      children: assessments.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(20),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),

                                blurRadius: 10,
                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // 🔥 HEADER
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  Text(
                                    "${getMonthName(item.month)} ${item.year}",

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 16,
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),

                                    decoration: BoxDecoration(
                                      color: Colors.blue,

                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    child: Text(
                                      item.total.toStringAsFixed(2),

                                      style: const TextStyle(
                                        color: Colors.white,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              scoreItem("Absensi", item.absensi),

                              scoreItem("Disiplin", item.disiplin),

                              scoreItem("Keterampilan", item.keterampilan),

                              scoreItem("Produktivitas", item.produktivitas),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 25),

                  // 🔥 MENU
                  AppCard(
                    child: Column(
                      children: [
                        actionItem(Icons.refresh, "Refresh Profile", () async {
                          await attendanceController.getCurrentUserData();

                          await attendanceController.getAssessments();

                          Get.snackbar(
                            "Success",
                            "Data berhasil diperbarui",

                            backgroundColor: Colors.green,

                            colorText: Colors.white,
                          );
                        }),

                        const Divider(),

                        actionItem(Icons.logout, "Logout", () async {
                          await attendanceController.logout();

                          Get.offAll(() => LoginPage());
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔥 VERSION
                  Center(
                    child: Text(
                      "Version 1.0.0",

                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // 🔥 PROFILE ITEM
  Widget profileItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: Colors.blue),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 3),

                Text(
                  value,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,

                    fontSize: 15,
                  ),

                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 SCORE ITEM
  Widget scoreItem(String title, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title),

          Text(
            value.toStringAsFixed(0),

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 🔥 ACTION ITEM
  Widget actionItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),

        child: Row(
          children: [
            Icon(icon, color: Colors.blue),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  // 🔥 MONTH NAME
  String getMonthName(int month) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[month];
  }
}
