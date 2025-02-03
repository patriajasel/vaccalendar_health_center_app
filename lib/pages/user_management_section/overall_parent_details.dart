import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';
import 'package:vaccalendar_health_center_app/utils/data_table_cells.dart';

class OverallParentDetails extends ConsumerWidget {
  const OverallParentDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    final searchQuery = ref.watch(searchQueryParentProvider);
    final searchController = ref.watch(searchControllerParentProvider);

    final usersData = ref.watch(userDataProvider).usersData;

    List<UserData> users = [];

    for (var user in usersData) {
      users.add(user);
    }

    if (searchController.text != searchQuery) {
      searchController.text = searchQuery;
      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchQuery.length),
      );
    }

    final filteredParent = users.where((users) {
      final query = searchQuery.toLowerCase();
      return users.userID.toLowerCase().contains(query) ||
          users.parentName.toLowerCase().contains(query) ||
          users.parentAge.toString().toLowerCase().contains(query) ||
          users.parentGender.toLowerCase().contains(query) ||
          users.address.toLowerCase().contains(query) ||
          users.email.toLowerCase().contains(query) ||
          users.number.toLowerCase().contains(query);
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
                    "Parent Details",
                    style: TextStyle(
                        fontFamily: 'SourGummy',
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                  height: screenHeight * 0.035,
                  width: screenWidth * 0.2,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: SearchBar(
                    controller: searchController,
                    hintText: 'Search...',
                    onChanged: (value) => ref
                        .read(searchQueryParentProvider.notifier)
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
                    borderRadius: BorderRadius.circular(10)),
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
                      DataTableCells().buildHeaderCell('Parent ID'),
                      DataTableCells().buildHeaderCell('Name'),
                      DataTableCells().buildHeaderCell('Age'),
                      DataTableCells().buildHeaderCell('Gender'),
                      DataTableCells().buildHeaderCell('Address'),
                      DataTableCells().buildHeaderCell('Email'),
                      DataTableCells().buildHeaderCell('Contact Number'),
                    ],
                  ),
                  // Data Rows
                  ...filteredParent.map((parent) {
                    return TableRow(children: [
                      DataTableCells().buildDataCell(parent.userID),
                      DataTableCells().buildDataCell(parent.parentName),
                      DataTableCells()
                          .buildDataCell(parent.parentAge.toString()),
                      DataTableCells().buildDataCell(parent.parentGender),
                      DataTableCells().buildDataCell(parent.address),
                      DataTableCells().buildStatusCell(parent.email),
                      DataTableCells().buildDataCell(parent.number),
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
