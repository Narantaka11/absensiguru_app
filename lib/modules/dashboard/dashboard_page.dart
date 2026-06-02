import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/home_content.dart';
import '../dashboard/schedule_page.dart';
import '../history/history_page.dart';
import '../dashboard/profile_page.dart';
import '../auth/dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = Get.put(DashboardController());

  final List<Widget> pages = [
    HomeContent(),
    SchedulePage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 WAJIB Obx biar reactive
      body: Obx(
        () => IndexedStack(index: controller.index.value, children: pages),
      ),

      // 🔥 NAVBAR FIX
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.index.value,
          onDestinationSelected: (i) {
            controller.changeTab(i);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.schedule_outlined),
              selectedIcon: Icon(Icons.schedule),
              label: "Jadwal",
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: "Riwayat",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
