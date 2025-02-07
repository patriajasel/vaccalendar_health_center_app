import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:vaccalendar_health_center_app/models/child_model.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';
import 'package:vaccalendar_health_center_app/models/vaccine_model.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

/**
 * TODO SECTION
 * 
 * ! CHECK CHILD IF THE VACCINES PICKED ARE ALREADY TAKEN
 */

class TodaySchedule extends ConsumerStatefulWidget {
  const TodaySchedule({super.key});

  @override
  ConsumerState<TodaySchedule> createState() => _TodayScheduleState();
}

class _TodayScheduleState extends ConsumerState<TodaySchedule> {
  late int finishedSchedules;
  late int pendingSchedules;
  late int overdueSchedules;
  late int totalSchedules;

  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    final chilDData = ref.watch(childDataProvider);
    final vaccineData = ref.watch(vaccineDataProvider).vaccines;

    final currentDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    List<ScheduleModel> todaysSchedules =
        getTodaysSchedules(ref.watch(scheduleDataProvider));

    arrangeScheduleData(todaysSchedules);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.01),
                  child: Text(
                    "Today's Vaccine Schedules",
                    style: TextStyle(
                        fontFamily: 'SourGummy',
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.01),
                  child: Text(
                    currentDate,
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.01),
                child: Divider(
                  color: Colors.black,
                  thickness: 2,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      Text(
                        finishedSchedules.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Text(
                        "Finished",
                        style: TextStyle(fontSize: 16, fontFamily: 'SourGummy'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.cyan,
                      ),
                      Text(
                        totalSchedules.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Text(
                        "Schedules",
                        style: TextStyle(fontSize: 16, fontFamily: 'SourGummy'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Column(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.yellowAccent.shade400,
                      ),
                      Text(
                        pendingSchedules.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Text(
                        "Pending",
                        style: TextStyle(fontSize: 16, fontFamily: 'SourGummy'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Column(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      Text(
                        overdueSchedules.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Text(
                        "Overdue",
                        style: TextStyle(fontSize: 16, fontFamily: 'SourGummy'),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.025),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              child: todaysSchedules.isNotEmpty
                  ? ListView.builder(
                      itemCount: todaysSchedules.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            List<String> childConditions = [];

                            List<ChildModel> child = chilDData.children
                                .where((child) =>
                                    child.childID ==
                                    todaysSchedules[index].childID)
                                .toList();

                            if (child.isNotEmpty) {
                              childConditions = child.first.childConditions;
                            }

                            showPopupScheduleInfo(
                                context,
                                ref,
                                screenHeight,
                                screenWidth,
                                todaysSchedules[index].schedID,
                                todaysSchedules[index].childID,
                                todaysSchedules[index].childName,
                                todaysSchedules[index].parent,
                                todaysSchedules[index].vaccineType,
                                todaysSchedules[index].schedStatus,
                                todaysSchedules[index].schedDate,
                                childConditions,
                                vaccineData);
                          },
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(
                                  color: Colors.cyan,
                                  width: 2,
                                )),
                            child: SizedBox(
                              height: screenHeight * 0.075,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    (index + 1).toString(),
                                    style: TextStyle(fontFamily: 'SourGummy'),
                                  ),
                                  VerticalDivider(),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Patient's ID",
                                          style: TextStyle(
                                            fontFamily: 'Hahmlet',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            todaysSchedules[index].childID,
                                            style: TextStyle(
                                                fontSize: 12, letterSpacing: 2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Child's Name",
                                          style: TextStyle(
                                            fontFamily: 'Hahmlet',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            todaysSchedules[index].childName,
                                            style: TextStyle(
                                                fontSize: 12, letterSpacing: 2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Parent's Name",
                                          style: TextStyle(
                                            fontFamily: 'Hahmlet',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            todaysSchedules[index].parent,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                letterSpacing: 1,
                                                fontSize: 12,
                                                fontFamily: "Hahmlet"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Vaccine Type",
                                          style: TextStyle(
                                            fontFamily: 'Hahmlet',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            todaysSchedules[index].vaccineType,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 12, letterSpacing: 2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Status",
                                          style: TextStyle(
                                            fontFamily: 'Hahmlet',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            todaysSchedules[index].schedStatus,
                                            style: TextStyle(
                                                color: todaysSchedules[index]
                                                            .schedStatus ==
                                                        "Pending"
                                                    ? Colors
                                                        .yellowAccent.shade700
                                                    : todaysSchedules[index]
                                                                .schedStatus ==
                                                            "Finished"
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontSize: 12,
                                                letterSpacing: 2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Text(
                        "No Schedules for today",
                        style: TextStyle(
                          fontFamily: 'Hahmlet',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            )),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }

  List<ScheduleModel> getTodaysSchedules(Schedules scheds) {
    List<ScheduleModel> schedulesToday = [];

    for (var sched in scheds.schedules) {
      if (DateFormat('yyyyMMdd').format(sched.schedDate) ==
          DateFormat('yyyyMMdd').format(DateTime.now())) {
        schedulesToday.add(sched);
      }
    }

    return schedulesToday;
  }

  void arrangeScheduleData(List<ScheduleModel> schedToday) {
    int total = schedToday.length;
    int finished = 0;
    int pending = 0;
    int overdue = 0;

    for (var sched in schedToday) {
      if (sched.schedStatus == "Finished") {
        finished++;
      } else if (sched.schedStatus == "Pending") {
        pending++;
      } else if (sched.schedStatus == "Overdue") {
        overdue++;
      }
    }

    totalSchedules = total;
    finishedSchedules = finished;
    pendingSchedules = pending;
    overdueSchedules = overdue;
  }

  void showPopupScheduleInfo(
      BuildContext context,
      WidgetRef ref,
      double screenHeight,
      double screenWidth,
      String scheduleID,
      String childID,
      String childName,
      String parent,
      String vaccineType,
      String vaccineStatus,
      DateTime schedDate,
      List<String> conditions,
      List<VaccineModel> vaccineData) {
    const leading = TextStyle(
        fontFamily: "Hahmlet",
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    const trailing =
        TextStyle(fontFamily: "Hahmlet", fontSize: 14, color: Colors.black);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.cyan.shade50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.cyan, width: 2)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Schedule Information",
                      style: TextStyle(
                        fontFamily: 'Hahmlet',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Confirm Cancel'),
                                  content: Text(
                                      "This will cancel the schedule. Are you sure you want to continue?"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                    ElevatedButton(
                                        onPressed: () async {
                                          final userID = FirebaseAuth
                                              .instance.currentUser!.uid;

                                          await FirebaseFirestoreServices()
                                              .deleteSchedule(scheduleID, ref);

                                          await FirebaseFirestoreServices()
                                              .addWorkerLogs(
                                                  userID,
                                                  'Admin',
                                                  DateTime.now(),
                                                  'Cancelled and remove the schedule($scheduleID)');

                                          if (context.mounted) {
                                            showTopSnackBar(
                                                Overlay.of(context),
                                                CustomSnackBar.success(
                                                    message:
                                                        "Schedule was cancelled"));
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text('Confirm'))
                                  ],
                                );
                              });
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("Cancel Schedule")
                          ],
                        ))
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
              ],
            ),
            content: SizedBox(
              height: screenHeight * 0.45,
              width: screenWidth * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Text("Schedule ID:", style: leading),
                    trailing: Text(scheduleID, style: trailing),
                  ),
                  ListTile(
                    leading: Text("Child ID:", style: leading),
                    trailing: Text(childID, style: trailing),
                  ),
                  ListTile(
                    leading: Text("Patient's Name:", style: leading),
                    trailing: Text(childName, style: trailing),
                  ),
                  ListTile(
                    leading: Text("Parent's Name:", style: leading),
                    trailing: Text(parent, style: trailing),
                  ),
                  ListTile(
                    leading: Text("Vaccine:", style: leading),
                    trailing: Text(vaccineType, style: trailing),
                  ),
                  ListTile(
                    leading: Text("Status:", style: leading),
                    trailing: Text(vaccineStatus, style: trailing),
                  ),
                  ListTile(
                    leading: Text("Schedule Date:", style: leading),
                    trailing: Text(
                        DateFormat('MMMM dd, yyyy')
                            .format(schedDate)
                            .toString(),
                        style: trailing),
                  ),
                  ListTile(
                    leading: Text("Child Conditions:", style: leading),
                    trailing: Text(
                        conditions.isEmpty
                            ? "No Conditions Listed"
                            : conditions.toString(),
                        style: trailing),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              iconColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            final userID =
                                FirebaseAuth.instance.currentUser!.uid;
                            final vaccineName = getVaccineName(vaccineType);

                            final vaccine = vaccineData.where((vaccine) =>
                                vaccine.vaccineName == vaccineName);

                            if (vaccine.first.stockCount == 0) {
                              showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                      message:
                                          "$vaccineName vaccine stock is empty. Cannot proceed with updating schedule"));
                            } else {
                              await FirebaseFirestoreServices()
                                  .updateScheduleStatus(scheduleID, 'Finished');
                              await FirebaseFirestoreServices()
                                  .obtainAllSchedules(ref);

                              await FirebaseFirestoreServices()
                                  .updateChildVaccineDetails(childID, "Yes",
                                      DateTime.now(), vaccineType);

                              await FirebaseFirestoreServices()
                                  .updateVaccineInventory(vaccineName,
                                      vaccine.first.stockCount - 1, ref);

                              await FirebaseFirestoreServices().addWorkerLogs(
                                  userID,
                                  'Admin',
                                  DateTime.now(),
                                  'Marked the schedule($scheduleID) as Finished');

                              await FirebaseFirestoreServices().addWorkerLogs(
                                  userID,
                                  'Admin',
                                  DateTime.now(),
                                  'Used 1 $vaccineType vaccine bottle for $childName($childID)');

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            child: Row(
                              children: [
                                Icon(Icons.check),
                                SizedBox(width: 3),
                                Text("Mark as Finished"),
                              ],
                            ),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              iconColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            final userID =
                                FirebaseAuth.instance.currentUser!.uid;

                            await FirebaseFirestoreServices()
                                .updateScheduleStatus(scheduleID, 'Overdue');
                            await FirebaseFirestoreServices()
                                .obtainAllSchedules(ref);

                            await FirebaseFirestoreServices().addWorkerLogs(
                                userID,
                                'Admin',
                                DateTime.now(),
                                'Marked the schedule($scheduleID) as Overdue');

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            child: Row(
                              children: [
                                Icon(Icons.cancel),
                                SizedBox(width: 3),
                                Text("Mark as Overdue"),
                              ],
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  String getVaccineName(String vaccineType) {
    switch (vaccineType) {
      case 'IPV1' || 'IPV2':
        return 'IPV';
      case 'OPV1' || 'OPV2' || 'OPV3':
        return 'OPV';
      case 'PCV1' || 'PCV2' || 'PCV3':
        return 'PCV';
      case 'Pentavalent 1st Dose' ||
            'Pentavalent 2nd Dose' ||
            'Pentavalent 3rd Dose':
        return 'Pentavalent';
      default:
        return vaccineType;
    }
  }
}
