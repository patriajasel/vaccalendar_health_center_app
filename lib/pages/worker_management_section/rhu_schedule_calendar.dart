import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vaccalendar_health_center_app/models/rhu_schedule_model.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';
import 'package:vaccalendar_health_center_app/utils/show_marked_rhu_dates.dart';

class RhuScheduleCalendar extends ConsumerStatefulWidget {
  const RhuScheduleCalendar({super.key});

  @override
  ConsumerState<RhuScheduleCalendar> createState() =>
      _RhuScheduleCalendarState();
}

class _RhuScheduleCalendarState extends ConsumerState<RhuScheduleCalendar> {
  List<DateTime> scheduleDate = [];
  List<RhuScheduleModel> scheduleToday = [];

  @override
  Widget build(BuildContext context) {
    final screenHeight = ref.watch(screenHeightProvider);
    final screenWidth = ref.watch(screenWidthProvider);

    final schedules = ref.watch(rhuScheduleProvider).rhuSchedules;

    final currentDate = DateTime.now();

    scheduleDate = schedules.map((schedule) => schedule.date).toList();

    return Card(
      elevation: 10,
      color: Colors.cyan.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(
            color: Colors.cyan,
            width: 2,
          )),
      child: SizedBox(
        height: screenHeight * 0.5,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.01),
              child: Text(
                "RHU Schedules & Announcement",
                style: TextStyle(
                    fontFamily: 'SourGummy',
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.01),
                child: Divider(
                  color: Colors.black,
                  thickness: 2,
                )),
            TableCalendar(
                calendarFormat: CalendarFormat.month,
                daysOfWeekHeight: screenHeight * 0.04,
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        fontFamily: "Hahmlet",
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontFamily: 'SourGummy',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  weekendStyle: TextStyle(
                    fontFamily: 'SourGummy',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    fontFamily: 'SourGummy',
                    fontSize: 18,
                  ),
                  canMarkersOverflow: false,
                  todayTextStyle: TextStyle(
                    fontFamily: 'SourGummy',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  todayDecoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(20)),
                  weekendTextStyle: TextStyle(
                    fontFamily: 'SourGummy',
                    fontSize: 18,
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  scheduleToday
                    ..clear()
                    ..addAll(
                      schedules.where((schedule) =>
                          schedule.date.year == selectedDay.year &&
                          schedule.date.month == selectedDay.month &&
                          schedule.date.day == selectedDay.day),
                    );

                  showDialog(
                      context: context,
                      builder: (context) => RhuMarkedDatesDialog(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          currentDate: currentDate,
                          schedToday: scheduleToday));
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (scheduleDate
                        .any((selectedDay) => isSameDay(selectedDay, day))) {
                      return Positioned(
                        top: screenHeight * 0.01,
                        right: screenHeight * 0.075,
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2020, 01, 01),
                lastDay: DateTime.utc(2040, 12, 31)),
          ],
        ),
      ),
    );
  }
}
