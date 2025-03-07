import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/models/workers_model.dart';
import 'package:vaccalendar_health_center_app/services/excel_services.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';
import 'package:vaccalendar_health_center_app/utils/data_table_cells.dart';

class OverallWorkerDetails extends ConsumerWidget {
  const OverallWorkerDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    final searchQuery = ref.watch(searchQueryWorkerProvider);
    final searchController = ref.watch(searchControllerWorkerProvider);

    final workerData = ref.watch(workerDataProvider).workers;

    List<WorkerModel> workers = [];

    for (var worker in workerData) {
      workers.add(worker);
    }

    if (searchController.text != searchQuery) {
      searchController.text = searchQuery;
      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchQuery.length),
      );
    }

    final filteredWorkers = workers.where((worker) {
      final query = searchQuery.toLowerCase();
      return worker.surname.toLowerCase().contains(query) ||
          worker.firstname.toLowerCase().contains(query) ||
          worker.middlename.toLowerCase().contains(query) ||
          worker.age.toString().toLowerCase().contains(query) ||
          DateFormat('MMMM dd, yyyy')
              .format(worker.birthdate)
              .toLowerCase()
              .contains(query) ||
          worker.gender.toLowerCase().contains(query) ||
          worker.address.toLowerCase().contains(query) ||
          worker.contactNumber.toLowerCase().contains(query) ||
          worker.emailAddress.toLowerCase().contains(query) ||
          worker.position.toLowerCase().contains(query);
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
                    "Worker Details",
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
                      onPressed: () async {
                        // await ExcelServices().exportWorkerData(workers); remove once there is already a worker registered

                        final userID = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestoreServices().addWorkerLogs(
                            userID,
                            'Admin',
                            DateTime.now(),
                            'Exported All Worker Data to Excel');
                      },
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
                        .read(searchQueryWorkerProvider.notifier)
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
              child: filteredWorkers.isNotEmpty
                  ? Table(
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
                            DataTableCells().buildHeaderCell('ID Number'),
                            DataTableCells().buildHeaderCell('Last Name'),
                            DataTableCells().buildHeaderCell('First Name'),
                            DataTableCells().buildHeaderCell('Middle Name'),
                            DataTableCells().buildHeaderCell('Age'),
                            DataTableCells().buildHeaderCell('Birthday'),
                            DataTableCells().buildHeaderCell('Gender'),
                            DataTableCells().buildHeaderCell('Address'),
                            DataTableCells().buildHeaderCell('Contact Number'),
                            DataTableCells().buildHeaderCell('Email Address'),
                            DataTableCells().buildHeaderCell('Position'),
                            DataTableCells().buildHeaderCell('Login Codes'),
                            DataTableCells().buildHeaderCell('Actions'),
                          ],
                        ),
                        // Data Rows
                        ...filteredWorkers.map((worker) {
                          return TableRow(children: [
                            DataTableCells().buildDataCell(worker.workerID),
                            DataTableCells().buildDataCell(worker.surname),
                            DataTableCells().buildDataCell(worker.firstname),
                            DataTableCells().buildDataCell(worker.middlename),
                            DataTableCells()
                                .buildDataCell(worker.age.toString()),
                            DataTableCells().buildDataCell(
                                DateFormat('MMMM dd, yyyy')
                                    .format(worker.birthdate)),
                            DataTableCells().buildStatusCell(worker.gender),
                            DataTableCells().buildDataCell(worker.address),
                            DataTableCells()
                                .buildDataCell(worker.contactNumber),
                            DataTableCells().buildDataCell(worker.emailAddress),
                            DataTableCells().buildHeaderCell(worker.loginCodes),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.01,
                                  vertical: screenHeight * 0.01),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white),
                                  onPressed: worker.whenCodeGenerated != null &&
                                          worker.whenCodeGenerated!.day !=
                                              DateTime.now().day
                                      ? () async {
                                          String codeGenerated =
                                              generateRandomString(8);

                                          await FirebaseFirestoreServices()
                                              .updateCodeGenerated(
                                                  worker.workerID,
                                                  codeGenerated,
                                                  DateTime.now());

                                          if (context.mounted) {
                                            await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Code Generated'),
                                                    content: Text(
                                                      codeGenerated,
                                                      style: TextStyle(
                                                          fontSize: 30),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Okay'))
                                                    ],
                                                  );
                                                });
                                          }
                                        }
                                      : null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.qr_code,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        "Generate Code",
                                        style:
                                            TextStyle(fontFamily: 'SourGummy'),
                                      )
                                    ],
                                  )),
                            )
                          ]);
                        })
                      ],
                    )
                  : Center(
                      child: Text(
                        'No worker data',
                        style: TextStyle(
                          fontFamily: 'Hahmlet',
                          fontWeight: FontWeight.bold,
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

  String generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
