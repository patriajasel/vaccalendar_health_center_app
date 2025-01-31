import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/pages/dialog_popups/set_schedule_dialog.dart';
import 'package:vaccalendar_health_center_app/pages/schedules_pages/overall_chart.dart';
import 'package:vaccalendar_health_center_app/pages/schedules_pages/overall_schedule_records.dart';
import 'package:vaccalendar_health_center_app/pages/schedules_pages/today_schedule.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulesState();
}

class _SchedulesState extends ConsumerState<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the Page
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
                  vertical: screenHeight * 0.025),
              child: Row(
                children: [
                  Text(
                    "Schedules",
                    style: TextStyle(
                        fontFamily: 'Hahmlet',
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  width: 2, color: Colors.cyan.shade700)),
                          backgroundColor: Colors.white,
                          elevation: 5,
                          fixedSize:
                              Size(screenWidth * 0.175, screenHeight * 0.05)),
                      onPressed: () {
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SetScheduleDialog();
                              });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.cyan,
                          ),
                          SizedBox(
                            width: screenWidth * 0.005,
                          ),
                          Text(
                            "Set a new vaccination schedule",
                            style: TextStyle(
                                fontFamily: 'Hahmlet',
                                fontSize: 16,
                                color: Colors.black),
                          )
                        ],
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025,
              ),
              child: Divider(
                color: Colors.black,
                thickness: 4,
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenHeight * 0.025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Today's Schedule Section
                        Expanded(child: TodaySchedule()),
                        SizedBox(width: screenWidth * 0.025),
                        // Overall Schedules Percent
                        Expanded(child: OverallChart())
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025,
                          vertical: screenHeight * 0.025),
                      child: OverallScheduleRecords())
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
