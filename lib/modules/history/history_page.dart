import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/widgets/app_card.dart';
import '../../data/models/responses.dart';
import '../../data/services/presence_repository.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDay = DateTime.now();

  String selectedTab = 'absen';

  final PresenceRepository repository = PresenceRepository();

  List<Presence> presences = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // 🔥 LOAD HISTORY
  Future<void> loadHistory() async {
    try {
      final result = await repository.getPresenceHistory(
        month: selectedDay.month.toString(),

        year: selectedDay.year.toString(),
      );

      setState(() {
        presences = result;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  // 🔥 EVENT CALENDAR
  List<String> getEventsForDay(DateTime day) {
    return presences
        .where((e) {
          if (e.date.isEmpty) {
            return false;
          }

          final date = DateTime.parse(e.date);

          return date.year == day.year &&
              date.month == day.month &&
              date.day == day.day;
        })
        .map((e) => e.status)
        .toList();
  }

  // 🔥 FILTER DATA
  List<Presence> getFilteredData() {
    if (selectedTab == 'absen') {
      return presences.where((e) {
        return e.status == 'hadir' || e.status == 'terlambat';
      }).toList();
    }

    if (selectedTab == 'telat') {
      return presences.where((e) {
        return e.status == 'terlambat';
      }).toList();
    }

    if (selectedTab == 'izin') {
      return presences.where((e) {
        return e.status == 'izin';
      }).toList();
    }

    if (selectedTab == 'sakit') {
      return presences.where((e) {
        return e.status == 'sakit';
      }).toList();
    }

    if (selectedTab == 'alpa') {
      return presences.where((e) {
        return e.status == 'alpa';
      }).toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // 🔥 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Riwayat",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  CircleAvatar(
                    backgroundColor: Colors.indigo.withOpacity(0.1),

                    child: const Icon(Icons.person, color: Colors.indigo),
                  ),
                ],
              ),

              const SizedBox(height: 20),

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

                              selectedDayPredicate: (day) {
                                return isSameDay(day, selectedDay);
                              },

                              // 🔥 SWIPE BULAN
                              onPageChanged: (focusedDay) async {
                                setState(() {
                                  selectedDay = focusedDay;

                                  isLoading = true;
                                });

                                await loadHistory();
                              },

                              // 🔥 PILIH TANGGAL
                              onDaySelected: (selected, focused) async {
                                setState(() {
                                  selectedDay = selected;

                                  isLoading = true;
                                });

                                await loadHistory();
                              },

                              // 🔥 EVENT
                              eventLoader: getEventsForDay,

                              calendarBuilders: CalendarBuilders(
                                // 🔥 EVENT COLOR
                                defaultBuilder: (context, day, focusedDay) {
                                  final events = getEventsForDay(day);

                                  if (events.isEmpty) {
                                    return null;
                                  }

                                  final status = events.last;

                                  Color bgColor = Colors.transparent;

                                  switch (status) {
                                    case 'hadir':
                                      bgColor = const Color(0xFFCFEED4);

                                      break;

                                    case 'terlambat':
                                      bgColor = const Color(0xFFF6E7B0);

                                      break;

                                    case 'izin':
                                      bgColor = const Color(0xFFDCD6FF);

                                      break;

                                    case 'sakit':
                                      bgColor = const Color(0xFFD7E6FF);

                                      break;

                                    case 'alpa':
                                      bgColor = const Color(0xFFFFD6D6);

                                      break;

                                    default:
                                      bgColor = Colors.transparent;
                                  }

                                  return Container(
                                    margin: const EdgeInsets.all(6),

                                    decoration: BoxDecoration(
                                      color: bgColor,

                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                    child: Center(
                                      child: Text(
                                        '${day.day}',

                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },

                                // 🔥 SELECTED DAY
                                selectedBuilder: (context, day, focusedDay) {
                                  return Container(
                                    margin: const EdgeInsets.all(6),

                                    decoration: BoxDecoration(
                                      color: Colors.black,

                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                    child: Center(
                                      child: Text(
                                        '${day.day}',

                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            // 🔥 LEGEND
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,

                              children: [
                                legendItem(const Color(0xFF5DBB63), "Hadir"),

                                legendItem(const Color(0xFFE6B800), "Telat"),

                                legendItem(const Color(0xFF8B5CF6), "Izin"),

                                legendItem(const Color(0xFF60A5FA), "Sakit"),

                                legendItem(const Color(0xFFFF6B6B), "Alpa"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔥 TAB FILTER
                      Row(
                        children: [
                          Expanded(
                            child: tabButton(
                              "absen",

                              "Absen",

                              Icons.check_circle,

                              const Color(0xFF5DBB63),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: tabButton(
                              "telat",

                              "Telat",

                              Icons.warning,

                              const Color(0xFFE6B800),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: tabButton(
                              "izin",

                              "Izin",

                              Icons.assignment,

                              const Color(0xFF8B5CF6),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: tabButton(
                              "sakit",

                              "Sakit",

                              Icons.local_hospital,

                              const Color(0xFF60A5FA),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: tabButton(
                              "alpa",

                              "Alpa",

                              Icons.cancel,

                              const Color(0xFFFF6B6B),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 🔥 LOADING
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.all(30),

                          child: CircularProgressIndicator(),
                        )
                      // 🔥 LIST HISTORY
                      else
                        Builder(
                          builder: (_) {
                            final data = getFilteredData();

                            if (data.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(20),

                                child: Text("Belum ada data bulan ini"),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,

                              physics: const NeverScrollableScrollPhysics(),

                              itemCount: data.length,

                              itemBuilder: (context, index) {
                                final item = data[index];

                                if (item.date.isEmpty) {
                                  return const SizedBox();
                                }

                                final parsedDate = DateTime.parse(item.date);

                                final tanggal =
                                    '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';

                                final jamMasuk = item.checkInTime ?? '-';

                                final jamKeluar = item.checkOutTime ?? '-';

                                Color color = Colors.grey;

                                IconData icon = Icons.help;

                                switch (item.status) {
                                  case 'hadir':
                                    color = const Color(0xFF5DBB63);

                                    icon = Icons.check_circle;

                                    break;

                                  case 'terlambat':
                                    color = const Color(0xFFE6B800);

                                    icon = Icons.warning;

                                    break;

                                  case 'izin':
                                    color = const Color(0xFF8B5CF6);

                                    icon = Icons.assignment;

                                    break;

                                  case 'sakit':
                                    color = const Color(0xFF60A5FA);

                                    icon = Icons.local_hospital;

                                    break;

                                  case 'alpa':
                                    color = const Color(0xFFFF6B6B);

                                    icon = Icons.cancel;

                                    break;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),

                                  child: AppCard(
                                    child: ListTile(
                                      leading: Icon(icon, color: color),

                                      title: Text(tanggal),

                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          const SizedBox(height: 4),

                                          Text('Masuk : $jamMasuk'),

                                          Text('Pulang : $jamKeluar'),
                                        ],
                                      ),

                                      trailing: Text(
                                        item.status.toUpperCase(),

                                        style: TextStyle(
                                          color: color,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
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

  // 🔥 TAB BUTTON
  Widget tabButton(String key, String title, IconData icon, Color color) {
    final isActive = selectedTab == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = key;
        });
      },

      child: AnimatedScale(
        scale: isActive ? 0.95 : 1.0,

        duration: const Duration(milliseconds: 150),

        child: AppCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),

            child: Column(
              children: [
                Icon(icon, color: isActive ? color : Colors.grey),

                const SizedBox(height: 6),

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
      ),
    );
  }

  // 🔥 LEGEND
  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,

          height: 10,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 5),

        Text(text),
      ],
    );
  }
}
