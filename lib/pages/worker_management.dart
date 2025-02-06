import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/pages/dialog_popups/set_rhu_schedule.dart';
import 'package:vaccalendar_health_center_app/pages/worker_management_section/overall_worker_details.dart';
import 'package:vaccalendar_health_center_app/pages/worker_management_section/rhu_schedule_calendar.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class WorkerManagement extends ConsumerStatefulWidget {
  const WorkerManagement({super.key});

  @override
  ConsumerState<WorkerManagement> createState() => _WorkerManagementState();
}

class _WorkerManagementState extends ConsumerState<WorkerManagement> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.white10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight * 0.025),
                child: Row(
                  children: [
                    Text(
                      "Worker's Data",
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
                                Size(screenWidth * 0.15, screenHeight * 0.05)),
                        onPressed: () {
                          if (context.mounted) {
                            showDialog(
                                context: context,
                                builder: (context) => SetRhuSchedule());
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 30,
                              color: Colors.cyan,
                            ),
                            SizedBox(
                              width: screenWidth * 0.005,
                            ),
                            Text(
                              "Set New RHU Schedule",
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
                        child: OverallWorkerDetails()),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025,
                            vertical: screenHeight * 0.025),
                        child: RhuScheduleCalendar()),
                  ],
                ),
              )),
            ],
          )),
    );
  }
}
