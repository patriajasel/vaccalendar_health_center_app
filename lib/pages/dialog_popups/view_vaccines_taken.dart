import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class ViewVaccinesTaken extends ConsumerWidget {
  final VaccineData vaccinesTaken;
  const ViewVaccinesTaken({super.key, required this.vaccinesTaken});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            "View Vaccines",
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
        height: screenHeight * 0.5,
        width: screenWidth * 0.2,
        child: SingleChildScrollView(
          child: Column(children: [
            generateListTile(
                vaccinesTaken.bcgVaccine, 'BCG', vaccinesTaken.bcgDate),
            generateListTile(vaccinesTaken.hepaVaccine, 'Hepatitis B',
                vaccinesTaken.hepaDate),
            generateListTile(
                vaccinesTaken.opv1Vaccine, 'OPV1', vaccinesTaken.opv1Date),
            generateListTile(
                vaccinesTaken.opv2Vaccine, 'OPV2', vaccinesTaken.opv2Date),
            generateListTile(
                vaccinesTaken.opv3Vaccine, 'OPV3', vaccinesTaken.opv3Date),
            generateListTile(
                vaccinesTaken.ipv1Vaccine, 'IPV1', vaccinesTaken.ipv1Date),
            generateListTile(
                vaccinesTaken.ipv2Vaccine, 'IPV2', vaccinesTaken.ipv2Date),
            generateListTile(
                vaccinesTaken.pcv1Vaccine, 'PCV1', vaccinesTaken.pcv1Date),
            generateListTile(
                vaccinesTaken.pcv2Vaccine, 'PCV2', vaccinesTaken.pcv2Date),
            generateListTile(
                vaccinesTaken.pcv3Vaccine, 'PCV3', vaccinesTaken.pcv3Date),
            generateListTile(vaccinesTaken.penta1Vaccine, 'Pentavalent 1',
                vaccinesTaken.penta1Date),
            generateListTile(vaccinesTaken.penta2Vaccine, 'Pentavalent 2',
                vaccinesTaken.penta2Date),
            generateListTile(vaccinesTaken.penta3Vaccine, 'Pentavalent 3',
                vaccinesTaken.penta3Date),
            generateListTile(
                vaccinesTaken.mmrVaccine, 'MMR', vaccinesTaken.mmrDate),
          ]),
        ),
      ),
    );
  }

  Widget generateListTile(
      String vaccineStatus, String vaccineName, DateTime? dateTaken) {
    return ListTile(
      leading: Icon(Icons.vaccines),
      title: Text(
        '$vaccineName Vaccine',
      ),
      titleTextStyle: TextStyle(
          fontFamily: 'Hahmlet',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black),
      subtitle: Text(
        "Date Taken: ${vaccineStatus == "Yes" ? DateFormat('MMMM dd. yyy').format(dateTaken!) : "Not Taken Yet"}",
      ),
      subtitleTextStyle: TextStyle(
          fontFamily: 'SourGummy',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey),
      trailing: Checkbox(
        value: vaccineStatus == "Yes" ? true : false,
        onChanged: null,
        checkColor: Colors.white,
        fillColor: vaccineStatus == "Yes"
            ? WidgetStatePropertyAll(Colors.green)
            : WidgetStatePropertyAll(Colors.white),
      ),
    );
  }
}
