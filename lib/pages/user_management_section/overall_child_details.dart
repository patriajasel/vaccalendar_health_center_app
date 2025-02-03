import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';
import 'package:vaccalendar_health_center_app/pages/dialog_popups/view_vaccines_taken.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';
import 'package:vaccalendar_health_center_app/utils/data_table_cells.dart';

class OverallChildDetails extends ConsumerWidget {
  const OverallChildDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    final searchQuery = ref.watch(searchQueryChildProvider);
    final searchController = ref.watch(searchControllerChildProvider);

    final usersData = ref.watch(userDataProvider).usersData;

    List<ChildrenData> children = [];

    for (var user in usersData) {
      for (var child in user.children) {
        children.add(child);
      }
    }

    if (searchController.text != searchQuery) {
      searchController.text = searchQuery;
      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchQuery.length),
      );
    }

    final filteredChildren = children.where((child) {
      final query = searchQuery.toLowerCase();
      return child.childID.toLowerCase().contains(query) ||
          child.childName.toLowerCase().contains(query) ||
          child.childAge.toLowerCase().contains(query) ||
          child.childGender.toLowerCase().contains(query) ||
          DateFormat('MMMM dd, yyyy')
              .format(child.birthdate!)
              .toLowerCase()
              .contains(query) ||
          child.childWeight.toLowerCase().contains(query) ||
          child.childHeight.toLowerCase().contains(query) ||
          child.birthplace.toLowerCase().contains(query);
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
                    "Child Details",
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
                        .read(searchQueryChildProvider.notifier)
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
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.01),
              child: Table(
                border: TableBorder.all(
                    color: Colors.blueGrey,
                    width: 2,
                    borderRadius:
                        BorderRadius.circular(10)), // Adds borders to the table
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
                      DataTableCells().buildHeaderCell('Child ID'),
                      DataTableCells().buildHeaderCell('Name'),
                      DataTableCells().buildHeaderCell('Age'),
                      DataTableCells().buildHeaderCell('Gender'),
                      DataTableCells().buildHeaderCell('Height'),
                      DataTableCells().buildHeaderCell('Weight'),
                      DataTableCells().buildHeaderCell('Birthdate'),
                      DataTableCells().buildHeaderCell('Birthplace'),
                      DataTableCells().buildHeaderCell('Vaccines Taken'),
                    ],
                  ),
                  // Data Rows
                  ...filteredChildren.map((child) {
                    return TableRow(children: [
                      DataTableCells().buildDataCell(child.childID),
                      DataTableCells().buildDataCell(child.childName),
                      DataTableCells().buildDataCell(child.childAge),
                      DataTableCells().buildDataCell(child.childGender),
                      DataTableCells().buildDataCell(child.childHeight),
                      DataTableCells().buildStatusCell(child.childWeight),
                      DataTableCells().buildDataCell(
                          DateFormat('MMMM dd, yyyy').format(child.birthdate!)),
                      DataTableCells().buildDataCell(child.birthplace),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01,
                            vertical: screenHeight * 0.01),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ViewVaccinesTaken(
                                      vaccinesTaken: child.vaccines));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "View",
                                  style: TextStyle(fontFamily: 'SourGummy'),
                                )
                              ],
                            )),
                      )
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
}
