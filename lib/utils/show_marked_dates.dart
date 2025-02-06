import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';

class MarkedDayDialog extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final List<ScheduleModel>? schedToday;
  final DateTime currentDate;

  const MarkedDayDialog({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    this.schedToday,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
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
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  _buildTextSpan("Schedule ID: ",
                                      schedToday![index].schedID),
                                  _buildTextSpan(
                                      "Date: ",
                                      DateFormat('MMMM dd, yyyy').format(
                                          schedToday![index].schedDate)),
                                  _buildTextSpan(
                                      "Child: ", schedToday![index].childName),
                                  _buildTextSpan("Vaccine: ",
                                      "${schedToday![index].vaccineType} vaccine"),
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
