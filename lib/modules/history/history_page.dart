import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/widgets/app_card.dart';
import '../auth/attendance_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDay = DateTime.now();
  String selectedTab = "absen";

  final controller = Get.find<AttendanceController>();

  List<String> getEventsForDay(DateTime day) {
    return controller.getByDate(day).map((e) => e.status).toList();
  }

  List<AttendanceModel> getFilteredData() {
    final data = controller.getByMonth(selectedDay);

    if (selectedTab == "absen") {
      return data.where((e) => e.status == "hadir").toList();
    } else if (selectedTab == "telat") {
      return data.where((e) => e.status == "telat").toList();
    } else if (selectedTab == "izin") {
      return data.where((e) => e.status == "izin").toList();
    } else if (selectedTab == "sakit") {
      return data.where((e) => e.status == "sakit").toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              // 🔹 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Riwayat",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  CircleAvatar(child: Icon(Icons.person)),
                ],
              ),

              SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      // 🔥 CALENDAR
                      AppCard(
                        child: Column(
                          children: [
                            TableCalendar(
                              firstDay: DateTime.utc(2020),
                              lastDay: DateTime.utc(2030),
                              focusedDay: selectedDay,
                              selectedDayPredicate: (day) =>
                                  isSameDay(day, selectedDay),
                              onDaySelected: (selected, focused) {
                                setState(() {
                                  selectedDay = selected;
                                });
                              },
                              eventLoader: getEventsForDay,

                              calendarBuilders: CalendarBuilders(
                                defaultBuilder:
                                    (context, day, focusedDay) {
                                  final events = getEventsForDay(day);
                                  if (events.isEmpty) return null;

                                  final status = events.last;

                                  Color bgColor;

                                  switch (status) {
                                    case "hadir":
                                      bgColor =
                                          Colors.green.withOpacity(0.3);
                                      break;
                                    case "telat":
                                      bgColor =
                                          Colors.orange.withOpacity(0.3);
                                      break;
                                    case "izin":
                                      bgColor =
                                          Colors.blue.withOpacity(0.3);
                                      break;
                                    case "sakit":
                                      bgColor =
                                          Colors.red.withOpacity(0.3);
                                      break;
                                    default:
                                      bgColor = Colors.transparent;
                                  }

                                  return Container(
                                    margin: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text('${day.day}',
                                          style: TextStyle(
                                              fontWeight:
                                                  FontWeight.bold)),
                                    ),
                                  );
                                },

                                selectedBuilder:
                                    (context, day, focusedDay) {
                                  return Container(
                                    margin: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text('${day.day}',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  );
                                },

                                markerBuilder:
                                    (context, day, events) {
                                  if (events.isEmpty) return SizedBox();

                                  final status = events.last;

                                  Color color;

                                  switch (status) {
                                    case "hadir":
                                      color = Colors.green;
                                      break;
                                    case "telat":
                                      color = Colors.orange;
                                      break;
                                    case "izin":
                                      color = Colors.blue;
                                      break;
                                    case "sakit":
                                      color = Colors.red;
                                      break;
                                    default:
                                      color = Colors.grey;
                                  }

                                  return Positioned(
                                    bottom: 4,
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            // 🔹 LEGEND
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                legendItem(Colors.green, "Hadir"),
                                legendItem(Colors.orange, "Telat"),
                                legendItem(Colors.blue, "Izin"),
                                legendItem(Colors.red, "Sakit"),
                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // 🔥 TAB BUTTON (UPDATED STYLE)
                      Row(
                        children: [
                          Expanded(
                              child: tabButton(
                                  "absen",
                                  "Absen",
                                  Icons.check_circle,
                                  Colors.green)),
                          SizedBox(width: 10),
                          Expanded(
                              child: tabButton("telat", "Telat",
                                  Icons.warning, Colors.orange)),
                          SizedBox(width: 10),
                          Expanded(
                              child: tabButton("izin", "Izin",
                                  Icons.assignment, Colors.blue)),
                          SizedBox(width: 10),
                          Expanded(
                              child: tabButton("sakit", "Sakit",
                                  Icons.local_hospital, Colors.red)),
                        ],
                      ),

                      SizedBox(height: 20),

                      // 🔥 LIST
                      Builder(
                        builder: (_) {
                          final data = getFilteredData();

                          if (data.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(20),
                              child:
                                  Text("Belum ada data bulan ini"),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];

                              String tanggal =
                                  "${item.dateTime.day}/${item.dateTime.month}";
                              String jam =
                                  "${item.dateTime.hour.toString().padLeft(2, '0')}:${item.dateTime.minute.toString().padLeft(2, '0')}";

                              Color color;
                              IconData icon;

                              switch (item.status) {
                                case "hadir":
                                  color = Colors.green;
                                  icon = Icons.check_circle;
                                  break;
                                case "telat":
                                  color = Colors.orange;
                                  icon = Icons.warning;
                                  break;
                                case "izin":
                                  color = Colors.blue;
                                  icon = Icons.assignment;
                                  break;
                                case "sakit":
                                  color = Colors.red;
                                  icon = Icons.local_hospital;
                                  break;
                                default:
                                  color = Colors.grey;
                                  icon = Icons.help;
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AppCard(
                                  child: ListTile(
                                  leading: Icon(icon, color: color),
                                  title: Text("$tanggal • $jam"),
                                  trailing: Text(
                                    item.status.toUpperCase(),
                                    style: TextStyle(
                                        color: color,
                                        fontWeight:
                                            FontWeight.bold),
                                    ),
                                  ),
                                )
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 TAB STYLE BARU
  Widget tabButton(
      String key, String title, IconData icon, Color color) {
    bool isActive = selectedTab == key;

    return GestureDetector(
      onTapDown: (_) => setState(() => selectedTab = key),
      child: AnimatedScale(
        scale: isActive ? 0.95 : 1.0,
        duration: Duration(milliseconds: 150),
        child: AppCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isActive ? color : Colors.grey),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? color : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
