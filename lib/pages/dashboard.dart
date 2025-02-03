import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/pages/dashboard_section/vaccine_completion_rate.dart';
import 'package:vaccalendar_health_center_app/pages/schedules_section/overall_schedule_records.dart';
import 'package:vaccalendar_health_center_app/pages/schedules_section/today_schedule.dart';
import 'package:vaccalendar_health_center_app/pages/vaccine_section/vaccine_inventory.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
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
              child: Text(
                "Dashboard",
                style: TextStyle(
                    fontFamily: 'Hahmlet',
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
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
                        Expanded(child: VaccineCompletionRate())
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025,
                          vertical: screenHeight * 0.025),
                      child: VaccineInventory()),
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
