import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class OverallChart extends ConsumerStatefulWidget {
  const OverallChart({super.key});

  @override
  ConsumerState<OverallChart> createState() => _OverallChartState();
}

class _OverallChartState extends ConsumerState<OverallChart> {
  late int finishedSchedules;
  late int pendingSchedules;
  late int overdueSchedules;
  late int totalSchedules;

  late List<double> chartValues = [20.0, 40.0, 30.0];

  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    final allSchedules = ref.watch(scheduleDataProvider);

    arrangeChartData(allSchedules.schedules);

    final total = chartValues.reduce((a, b) => a + b);

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
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.01),
              child: Text(
                "Overall Percentage",
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
                child: Divider(
                  color: Colors.black,
                  thickness: 2,
                )),
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        allSchedules.schedules.length.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'SourGummy',
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Schedules",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'SourGummy',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.25),
                Center(
                  child: SizedBox(
                    height: screenHeight * 0.225,
                    width: screenWidth * 0.225,
                    child: PieChart(
                      PieChartData(
                        sections: chartValues.asMap().entries.map((entry) {
                          final index = entry.key;
                          final value = entry.value;

                          // Normalize the value to calculate percentage
                          final percentage =
                              total > 0 ? (value / total) * 100 : 0.0;
                          final colors = [
                            Colors.red,
                            Colors.yellow,
                            Colors.green
                          ];

                          return PieChartSectionData(
                            titlePositionPercentageOffset: 1.3,
                            value:
                                percentage, // Use the percentage as the value
                            color: colors[index],
                            title:
                                '${percentage.toStringAsFixed(1)}%', // Display percentage as the title
                            titleStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Center(
              child: Text(
                "Overall Schedule Percentage",
                maxLines: 2,
                style: TextStyle(
                    fontFamily: 'SourGummy',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Column(
                    children: [
                      Text(
                        finishedSchedules.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        color: Colors.green,
                      ),
                      Text(
                        "Finished",
                        style: TextStyle(fontSize: 16, fontFamily: 'SourGummy'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Column(
                    children: [
                      Text(
                        pendingSchedules.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        color: Colors.yellowAccent.shade400,
                      ),
                      Text(
                        "Pending",
                        style: TextStyle(fontSize: 16, fontFamily: 'SourGummy'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Column(
                    children: [
                      Text(
                        overdueSchedules.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        color: Colors.red,
                      ),
                      Text(
                        "Overdue",
                        style: TextStyle(fontSize: 16, fontFamily: 'SourGummy'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void arrangeChartData(List<ScheduleModel> schedToday) {
    chartValues.clear();

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

    chartValues.addAll([
      overdue.toDouble(),
      pending.toDouble(),
      finished.toDouble(),
    ]);
  }
}
