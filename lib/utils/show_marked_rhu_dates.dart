import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/models/rhu_schedule_model.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';

class RhuMarkedDatesDialog extends ConsumerWidget {
  final double screenHeight;
  final double screenWidth;
  final List<RhuScheduleModel>? schedToday;
  final DateTime currentDate;

  const RhuMarkedDatesDialog({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    this.schedToday,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: Colors.cyan.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This Day's Schedule",
            style: TextStyle(
                fontFamily: 'DMSerif',
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          )
        ],
      ),
      content: SizedBox(
        width: screenWidth * 0.3,
        height: screenHeight * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: schedToday != null && schedToday!.isNotEmpty
                  ? ListView.builder(
                      itemCount: schedToday!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Schedule #${index + 1}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RadioCanada',
                                      fontSize: 18),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Confirm Delete'),
                                              content: Text(
                                                  'Are you sure you want to delete this RHU Schedule?'),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel')),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestoreServices()
                                                          .deleteRhuSchedule(
                                                              schedToday![index]
                                                                  .rhuID,
                                                              ref);
                                                      await FirebaseFirestoreServices()
                                                          .obtainRhuSchedules(
                                                              ref);
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text('Confirm')),
                                              ],
                                            );
                                          });
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  _buildTextSpan(
                                      "Title: ", schedToday![index].title),
                                  _buildTextSpan(
                                      "Date: ",
                                      DateFormat('MMMM dd, yyyy')
                                          .format(schedToday![index].date)),
                                  _buildTextSpan("Time: ",
                                      '${schedToday![index].startTime} to ${schedToday![index].endTime}'),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No Schedule for this day",
                        style: TextStyle(fontFamily: 'Mali'),
                      ),
                    ),
            ),
            SizedBox(height: screenHeight * 0.01)
          ],
        ),
      ),
    );
  }

  TextSpan _buildTextSpan(String label, String value) {
    return TextSpan(
      children: [
        TextSpan(
          text: label,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'RadioCanada',
              fontSize: 14),
        ),
        TextSpan(
          text: "$value\n",
          style: const TextStyle(fontFamily: 'RadioCanada', fontSize: 14),
        ),
      ],
    );
  }
}
