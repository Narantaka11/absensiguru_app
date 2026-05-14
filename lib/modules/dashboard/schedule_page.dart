import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_card.dart';
import '../../data/models/schedule_model.dart';
import '../../data/services/schedule_repository.dart';
import '../auth/dashboard_controller.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final dashboardController = Get.find<DashboardController>();

  final repository = ScheduleRepository();

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

  @override
  Widget build(BuildContext context) {
    final selectedDay = days[selectedDayIndex];

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

            // 🔥 TAB HARI
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
                      width: 100,

                      margin: EdgeInsets.only(right: 10),

                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[200],

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Center(
                        child: Text(
                          days[index],

                          style: TextStyle(
                            fontWeight: FontWeight.bold,

                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Jadwal $selectedDay",

              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            SizedBox(height: 15),

            // 🔥 REALTIME API
            Expanded(
              child: FutureBuilder<List<ScheduleModel>>(
                future: repository.getSchedules(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Gagal memuat jadwal'));
                  }

                  final schedules = snapshot.data ?? [];

                  // 🔥 FILTER PER HARI
                  final filtered = schedules
                      .where((e) => e.dayName == selectedDay)
                      .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        selectedDay == "Sabtu" || selectedDay == "Minggu"
                            ? "Hari Libur"
                            : "Tidak ada jadwal",

                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 20),

                    itemCount: filtered.length,

                    itemBuilder: (context, index) {
                      final item = filtered[index];

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
                                      item.subject,

                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),

                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      item.className,

                                      style: TextStyle(color: Colors.grey),

                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      '${item.startTime} - ${item.endTime}',

                                      style: TextStyle(color: Colors.blue),
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
