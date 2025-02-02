import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/pages/worker_management_section/overall_worker_details.dart';
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight * 0.025),
                child: Text(
                  "Worker's Data",
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
                        child: OverallWorkerDetails()),
                  ],
                ),
              )),
            ],
          )),
    );
  }
}
