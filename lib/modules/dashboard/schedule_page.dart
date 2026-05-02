import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_card.dart';
import '../auth/dashboard_controller.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final dashboardController = Get.find<DashboardController>();

  // 🔥 FIX: sekarang aman karena 7 hari
  int selectedDayIndex = DateTime.now().weekday - 1;

  final List<String> days = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  final Map<String, List<Map<String, String>>> schedules = {
    "Senin": [
      {"mapel": "Matematika", "jam": "07:00 - 08:30", "kelas": "X IPA 1"},
      {"mapel": "Fisika", "jam": "09:00 - 10:30", "kelas": "XI IPA 2"},
    ],
    "Selasa": [
      {"mapel": "Kimia", "jam": "08:00 - 09:30", "kelas": "X IPA 3"},
    ],
    "Rabu": [
      {"mapel": "Biologi", "jam": "07:00 - 08:30", "kelas": "XI IPA 1"},
    ],
    "Kamis": [],
    "Jumat": [
      {"mapel": "Matematika", "jam": "07:00 - 08:30", "kelas": "X IPA 2"},
    ],
    "Sabtu": [],
    "Minggu": [],
  };

  @override
  Widget build(BuildContext context) {
    final selectedDay = days[selectedDayIndex];
    final todaySchedules = schedules[selectedDay] ?? [];

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
                Text(
                  "Jadwal Mengajar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    dashboardController.changeTab(3);
                  },
                  child: CircleAvatar(child: Icon(Icons.person)),
                ),
              ],
            ),

            SizedBox(height: 20),

            // 🔥 HARI (SIMETRIS + SCROLL)
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedDayIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      width: 100, // 🔥 KUNCI SIMETRIS
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          days[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // 🔥 TITLE
            Text(
              "Jadwal $selectedDay",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            SizedBox(height: 15),

            // 🔥 LIST
            Expanded(
              child: todaySchedules.isEmpty
                  ? Center(
                      child: Text(
                        selectedDay == "Sabtu" || selectedDay == "Minggu"
                            ? "Hari Libur"
                            : "Tidak ada jadwal",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 20),
                      itemCount: todaySchedules.length,
                      itemBuilder: (context, index) {
                        final item = todaySchedules[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppCard(
                            child: Row(
                              children: [

                                // 🔥 ICON
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.school, color: Colors.blue),
                                ),

                                SizedBox(width: 15),

                                // 🔥 DETAIL
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["mapel"]!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        item["kelas"]!,
                                        style:
                                            TextStyle(color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        item["jam"]!,
                                        style:
                                            TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(Icons.arrow_forward_ios, size: 14),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
