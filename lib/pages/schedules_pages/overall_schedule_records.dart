import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchControllerProvider = Provider((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

class OverallScheduleRecords extends ConsumerWidget {
  const OverallScheduleRecords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);
    final overallSchedules = ref.watch(scheduleDataProvider).schedules;

    final searchQuery = ref.watch(searchQueryProvider);
    final searchController = ref.watch(searchControllerProvider);

    if (searchController.text != searchQuery) {
      searchController.text = searchQuery;
      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchQuery.length),
      );
    }

    final filteredSchedules = overallSchedules.where((schedule) {
      final query = searchQuery.toLowerCase();
      return schedule.schedID.toLowerCase().contains(query) ||
          schedule.childName.toLowerCase().contains(query) ||
          schedule.parent.toLowerCase().contains(query) ||
          schedule.vaccineType.toLowerCase().contains(query) ||
          DateFormat('MMMM dd, yyyy')
              .format(schedule.schedDate)
              .toLowerCase()
              .contains(query) ||
          schedule.schedStatus.toLowerCase().contains(query);
    }).toList();

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
        height: screenHeight * 0.6,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.01),
                  child: Text(
                    "Overall Schedule Records",
                    style: TextStyle(
                        fontFamily: 'SourGummy',
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          fixedSize:
                              Size(screenWidth * 0.1, screenHeight * 0.035),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.description, color: Colors.white),
                          SizedBox(width: 1),
                          Text('Export to Excel'),
                        ],
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                  height: screenHeight * 0.035,
                  width: screenWidth * 0.2,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: SearchBar(
                    controller: searchController,
                    hintText: 'Search...',
                    onChanged: (value) =>
                        ref.read(searchQueryProvider.notifier).state = value,
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    elevation: WidgetStatePropertyAll(0),
                    leading: Icon(Icons.search),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.cyan, width: 2))),
                  ),
                )
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
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.01),
              child: Table(
                border: TableBorder.all(), // Adds borders to the table
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
                },
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.cyan[200],
                    ),
                    children: [
                      _buildHeaderCell('Schedule ID'),
                      _buildHeaderCell('Child'),
                      _buildHeaderCell('Parent'),
                      _buildHeaderCell('Vaccine Type'),
                      _buildHeaderCell('Schedule Date'),
                      _buildHeaderCell('Vaccine Status'),
                    ],
                  ),
                  // Data Rows
                  ...filteredSchedules.map((schedule) {
                    return TableRow(children: [
                      _buildDataCell(schedule.schedID),
                      _buildDataCell(schedule.childName),
                      _buildDataCell(schedule.parent),
                      _buildDataCell(schedule.vaccineType),
                      _buildDataCell(
                        DateFormat('MMMM dd, yyyy').format(schedule.schedDate),
                      ),
                      _buildStatusCell(schedule.schedStatus),
                    ]);
                  })
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    Color statusColor = Colors.red;
    if (status == "Finished") {
      statusColor = Colors.green;
    } else if (status == "Pending") {
      statusColor = Colors.yellowAccent.shade700;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(color: statusColor),
      ),
    );
  }
}
