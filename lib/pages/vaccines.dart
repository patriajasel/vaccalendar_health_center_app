import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/pages/vaccine_section/vaccine_inventory.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class VaccinesManagement extends ConsumerStatefulWidget {
  const VaccinesManagement({super.key});

  @override
  ConsumerState<VaccinesManagement> createState() => _VaccinesManagementState();
}

class _VaccinesManagementState extends ConsumerState<VaccinesManagement> {
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
                "Vaccines",
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
                        Expanded(child: VaccineInventory()),
                        SizedBox(width: screenWidth * 0.025),
                        // Overall Schedules Percent
                        Expanded(child: VaccineInventory())
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
