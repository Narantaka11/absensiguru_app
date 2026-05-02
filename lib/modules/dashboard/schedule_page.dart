import 'package:flutter/material.dart';
import '../../../core/widgets/app_card.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {

    final schedules = [
      {
        "hari": "Senin",
        "mapel": "Matematika",
        "jam": "07:00 - 08:30",
        "kelas": "X IPA 1"
      },
      {
        "hari": "Selasa",
        "mapel": "Fisika",
        "jam": "08:30 - 10:00",
        "kelas": "XI IPA 2"
      },
      {
        "hari": "Rabu",
        "mapel": "Matematika",
        "jam": "10:00 - 11:30",
        "kelas": "X IPA 3"
      },
    ];

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
                Text("Jadwal Mengajar",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                CircleAvatar(child: Icon(Icons.person)),
              ],
            ),

            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final item = schedules[index];

                  return AppCard(
                    child: Row(
                      children: [

                        // 🔥 HARI
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.blue, size: 18),
                              SizedBox(height: 5),
                              Text(item["hari"]!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),

                        SizedBox(width: 15),

                        // 🔥 DETAIL
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(item["mapel"]!,
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(item["kelas"]!,
                                  style: TextStyle(
                                      color: Colors.grey)),
                              SizedBox(height: 5),
                              Text(item["jam"]!,
                                  style: TextStyle(
                                      color: Colors.blue)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
