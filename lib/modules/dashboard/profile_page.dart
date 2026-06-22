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
                  const Row(
                    children: [
                      const Text(
                        "Profile",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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

                        Column(
                          children: [
                            Text(
                              user?.teacher?.subject ?? "-",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "NIP ${user?.teacher?.nip ?? '-'}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "Informasi Guru",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),
                  // 🔥 DETAIL INFO
                  AppCard(
                    child: Column(
                      children: [
                        profileItem(Icons.email, "Email", user?.email ?? "-"),

                        profileItem(
                          Icons.badge,
                          "NIP",
                          user?.teacher?.nip ?? "-",
                        ),

                        profileItem(
                          Icons.menu_book,
                          "Mata Pelajaran",
                          user?.teacher?.subject ?? "-",
                        ),

                        profileItem(
                          Icons.work,
                          "Status",
                          user?.teacher?.status ?? "-",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔥 TITLE
                  const Text(
                    "Peringkat Kinerja",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

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
                        child: const Center(
                          child: Text("Belum ada data penilaian"),
                        ),
                      );
                    }

                    final latest = assessments.first;

                    Color rankColor = Colors.blue;
                    IconData rankIcon = Icons.emoji_events;

                    if (latest.ranking == 1) {
                      rankColor = Colors.amber;
                    } else if (latest.ranking == 2) {
                      rankColor = Colors.grey;
                    } else if (latest.ranking == 3) {
                      rankColor = Colors.brown;
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                        children: [
                          Icon(rankIcon, size: 40, color: rankColor),

                          const SizedBox(height: 10),

                          Text(
                            "#${latest.ranking}",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: rankColor,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            "Ranking Saat Ini",
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 8),

                          Divider(),

                          const SizedBox(height: 8),

                          rankingItem(
                            Icons.analytics,
                            "SAW Score",
                            latest.sawScore.toStringAsFixed(4),
                          ),

                          rankingItem(
                            Icons.star,
                            "Nilai Akhir",
                            latest.total.toStringAsFixed(2),
                          ),

                          rankingItem(
                            Icons.calendar_month,
                            "Periode",
                            "${getMonthName(latest.month)} ${latest.year}",
                          ),

                          rankingItem(
                            Icons.workspace_premium,
                            "Kategori",
                            latest.sawScore >= 0.90
                                ? "Sangat Baik"
                                : latest.sawScore >= 0.80
                                ? "Baik"
                                : latest.sawScore >= 0.70
                                ? "Cukup"
                                : "Perlu Pembinaan",
                          ),

                          const SizedBox(height: 15),

                          LinearProgressIndicator(
                            value: latest.sawScore,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // ======================
                  // SLIP GAJI
                  // ======================
                  AppCard(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        final salary = attendanceController.salary.value;

                        if (salary == null) {
                          Get.snackbar("Info", "Slip gaji belum tersedia");
                          return;
                        }

                        Get.bottomSheet(
                          Container(
                            padding: const EdgeInsets.all(24),

                            decoration: const BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),

                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Container(
                                  width: 60,
                                  height: 5,

                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,

                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                const Icon(
                                  Icons.receipt_long,
                                  size: 50,
                                  color: Colors.green,
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  salary.monthName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                rankingItem(
                                  Icons.payments,
                                  "Gaji Pokok",
                                  "Rp ${salary.baseSalary.toStringAsFixed(0)}",
                                ),

                                rankingItem(
                                  Icons.remove_circle_outline,
                                  "Potongan",
                                  "Rp ${salary.totalDeduction.toStringAsFixed(0)}",
                                ),

                                rankingItem(
                                  Icons.account_balance_wallet,
                                  "Total Gaji",
                                  "Rp ${salary.totalSalary.toStringAsFixed(0)}",
                                ),

                                rankingItem(
                                  Icons.info_outline,
                                  "Status",
                                  salary.statusLabel,
                                ),
                              ],
                            ),
                          ),
                        );
                      },

                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),

                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long, color: Colors.green),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    "Slip Gaji",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    attendanceController.salary.value != null
                                        ? "${attendanceController.salary.value!.monthName} • ${attendanceController.salary.value!.statusLabel}"
                                        : "Belum tersedia",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ======================
                  // LOGOUT
                  // ======================
                  AppCard(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),

                      onTap: () async {
                        await attendanceController.logout();

                        Get.offAll(() => const LoginPage());
                      },

                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),

                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),

                            SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                "Logout",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
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

  Widget rankingItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),

          const SizedBox(width: 10),

          Expanded(child: Text(title)),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
