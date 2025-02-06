import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class SetRhuSchedule extends ConsumerStatefulWidget {
  const SetRhuSchedule({super.key});

  @override
  ConsumerState<SetRhuSchedule> createState() => _SetRhuScheduleState();
}

class _SetRhuScheduleState extends ConsumerState<SetRhuSchedule> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeStartController = TextEditingController();
  final timeEndController = TextEditingController();

  @override
  void dispose() {
    timeEndController.dispose();
    dateController.dispose();
    timeStartController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);
    return AlertDialog(
      backgroundColor: Colors.cyan.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.cyan, width: 2)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RHU Schedule and Announcement Window",
            style: TextStyle(
              fontFamily: 'Hahmlet',
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
        ],
      ),
      content: SizedBox(
        height: screenHeight * 0.4,
        width: screenWidth * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            SizedBox(
              width: screenWidth * 0.3,
              child: TextField(
                controller: titleController,
                style: TextStyle(
                  fontFamily: 'Hahmlet',
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  label: Text("Date Title"),
                  labelStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'SourGummy',
                      color: Colors.blueGrey),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.cyan, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.cyan, width: 2)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            SizedBox(
              width: screenWidth * 0.3,
              child: TextField(
                controller: dateController,
                style: TextStyle(
                  fontFamily: 'Hahmlet',
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                  label: Text("Select Date"),
                  labelStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'SourGummy',
                      color: Colors.blueGrey),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.cyan, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.cyan, width: 2)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: timeStartController,
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.alarm),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.timer),
                        onPressed: () {
                          _selectTime(context, timeStartController);
                        },
                      ),
                      label: Text("Start Time"),
                      labelStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SourGummy',
                          color: Colors.blueGrey),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.cyan, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.cyan, width: 2)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: screenHeight * 0.01),
                Expanded(
                  child: TextField(
                    controller: timeEndController,
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.alarm_off),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.timer),
                        onPressed: () {
                          _selectTime(context, timeEndController);
                        },
                      ),
                      label: Text("End Time"),
                      labelStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SourGummy',
                          color: Colors.blueGrey),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.cyan, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.cyan, width: 2)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: Size(screenWidth * 0.1, screenHeight * 0.04),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black),
            onPressed: () async {},
            child: Text(
              "Cancel",
              style: TextStyle(
                  fontFamily: 'Hahmlet',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: Size(screenWidth * 0.125, screenHeight * 0.04),
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white),
            onPressed: () async {
              await FirebaseFirestoreServices().setNewRHUSchedule(
                  titleController.text,
                  DateTime.parse(dateController.text),
                  timeStartController.text,
                  timeEndController.text,
                  ref);

              await FirebaseFirestoreServices().obtainRhuSchedules(ref);

              if (context.mounted) {
                Navigator.pop(context);
                showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.success(
                        message: "RHU Schedule set successfully"));
              }
            },
            child: Text(
              "Set RHU Schedule",
              style: TextStyle(
                  fontFamily: 'Hahmlet',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
        print(dateController.text);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController time) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        time.text = pickedTime.format(context); // Format and display
      });
    }
  }
}
