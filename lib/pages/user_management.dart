import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/pages/dialog_popups/register_new_child.dart';
import 'package:vaccalendar_health_center_app/pages/user_management_section/overall_child_details.dart';
import 'package:vaccalendar_health_center_app/pages/user_management_section/overall_parent_details.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class UserManagement extends ConsumerStatefulWidget {
  const UserManagement({super.key});

  @override
  ConsumerState<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends ConsumerState<UserManagement> {
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
                child: Row(
                  children: [
                    Text(
                      "Patient's Data",
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
                                Size(screenWidth * 0.125, screenHeight * 0.05)),
                        onPressed: () {
                          if (context.mounted) {
                            showDialog(
                                context: context,
                                builder: (context) => RegisterNewChild());
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
                              "Register Child",
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
                        child: OverallChildDetails()),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025,
                            vertical: screenHeight * 0.025),
                        child: OverallParentDetails())
                  ],
                ),
              )),
            ],
          )),
    );
  }
}
