import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';
import 'package:vaccalendar_health_center_app/utils/data_table_cells.dart';

class OverallScheduleRecords extends ConsumerWidget {
  const OverallScheduleRecords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);
    final overallSchedules = ref.watch(scheduleDataProvider).schedules;

    final searchQuery = ref.watch(searchQuerySchedProvider);
    final searchController = ref.watch(searchControllerSchedProvider);

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
                    onChanged: (value) => ref
                        .read(searchQuerySchedProvider.notifier)
                        .state = value,
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.01),
                  child: Table(
                    border: TableBorder.all(
                        color: Colors.blueGrey,
                        width: 2,
                        borderRadius: BorderRadius.circular(
                            10)), // Adds borders to the table
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
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        children: [
                          DataTableCells().buildHeaderCell('Schedule ID'),
                          DataTableCells().buildHeaderCell('Child'),
                          DataTableCells().buildHeaderCell('Parent'),
                          DataTableCells().buildHeaderCell('Vaccine Type'),
                          DataTableCells().buildHeaderCell('Schedule Date'),
                          DataTableCells().buildHeaderCell('Vaccine Status'),
                        ],
                      ),
                      // Data Rows
                      ...filteredSchedules.map((schedule) {
                        return TableRow(children: [
                          DataTableCells().buildDataCell(schedule.schedID),
                          DataTableCells().buildDataCell(schedule.childName),
                          DataTableCells().buildDataCell(schedule.parent),
                          DataTableCells().buildDataCell(schedule.vaccineType),
                          DataTableCells().buildDataCell(
                            DateFormat('MMMM dd, yyyy')
                                .format(schedule.schedDate),
                          ),
                          DataTableCells()
                              .buildStatusCell(schedule.schedStatus),
                        ]);
                      })
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
