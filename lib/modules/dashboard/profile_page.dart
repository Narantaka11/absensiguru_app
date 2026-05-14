import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_card.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.settings),
              ],
            ),

            SizedBox(height: 20),

            // 🔥 PROFILE CARD (FIX OVERFLOW DI SINI)
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),

                  SizedBox(width: 15),

                  // 🔥 FIX UTAMA: EXPANDED
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Budi Santoso",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Guru Matematika",
                          style: TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 🔥 INFO DETAIL
            AppCard(
              child: Column(
                children: [
                  profileItem(Icons.email, "Email", "budi@sekolah.com"),
                  profileItem(Icons.badge, "Status", "Guru Tetap"),
                  profileItem(Icons.school, "NIP", "1987654321"),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 🔥 MENU
            AppCard(
              child: Column(
                children: [
                  actionItem(Icons.lock, "Ubah Password", () {}),

                  Divider(),

                  actionItem(Icons.logout, "Logout", () {
                    Get.offAll(() => LoginPage());
                  }),
                ],
              ),
            ),

            Spacer(),

            Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 PROFILE ITEM (ANTI OVERFLOW)
  Widget profileItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),

          // 🔥 FIX DI SINI JUGA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey)),
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 ACTION ITEM (AMAN)
  Widget actionItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: 10),

            Expanded(child: Text(title)), // 🔥 FIX

            Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
