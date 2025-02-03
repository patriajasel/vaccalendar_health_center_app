import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class VaccineCompletionRate extends ConsumerStatefulWidget {
  const VaccineCompletionRate({super.key});

  @override
  ConsumerState<VaccineCompletionRate> createState() =>
      _VaccineCompletionRateState();
}

class _VaccineCompletionRateState extends ConsumerState<VaccineCompletionRate> {
  late int vaccinatedCount;
  late int notVaccinatedCount;
  late int incompleteCount;

  late List<double> chartValues = [];

  List<String> vaccineList = [
    'All',
    'BCG',
    'Hepatitis B',
    'OPV',
    'IPV',
    'PCV',
    'Pentavalent',
    'MMR'
  ];

  String? selectedVaccine = 'All';

  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    final childData = ref.watch(childDataProvider).children;
    final userData = ref.watch(userDataProvider).usersData;

    arrangeCompletionRateData(userData, selectedVaccine, childData.length);

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
              child: Row(
                children: [
                  Text(
                    "Completion Rate",
                    style: TextStyle(
                        fontFamily: 'SourGummy',
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Expanded(
                    child: Container(
                      height: screenHeight * 0.040,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonFormField(
                        value: selectedVaccine,
                        items: vaccineList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedVaccine = val;
                          });
                        },
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            fontFamily: "Hahmlet"),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: "Vaccine",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontFamily: "SourGummy"),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyan.shade300, width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyan.shade400, width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                        childData.length.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'SourGummy',
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        childData.length > 1 ? "Children" : 'Child',
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
                            Colors.green,
                            Colors.yellowAccent,
                            Colors.red
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
                "Overall Vaccination Rate",
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
                        vaccinatedCount.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        color: Colors.green,
                      ),
                      Text(
                        "Vaccinated",
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
                        incompleteCount.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        color: Colors.yellowAccent,
                      ),
                      Text(
                        "Incomplete",
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
                        notVaccinatedCount.toString(),
                        style: TextStyle(fontSize: 50, fontFamily: 'Hahmlet'),
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        color: Colors.red,
                      ),
                      Text(
                        "Not Vaccinated",
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

  void arrangeCompletionRateData(
      List<UserData> userData, String? vaccine, int childLength) {
    chartValues.clear();

    late int vaccinated;
    late int notVaccinated;
    late int incomplete;

    if (vaccine != 'All') {
      vaccinated = countChildrenWithVaccine(userData, vaccine!);
      incomplete = countChildrenWithIncompleteVaccine(userData, vaccine);
    } else {
      vaccinated = countFullyVaccinatedChildren(userData);
      incomplete = countIncompleteVaccinatedChildren(userData);
    }

    notVaccinated = childLength - (vaccinated + incomplete);

    chartValues.addAll([
      vaccinated.toDouble(),
      incomplete.toDouble(),
      notVaccinated.toDouble(),
    ]);

    setState(() {
      vaccinatedCount = vaccinated;
      notVaccinatedCount = notVaccinated;
      incompleteCount = incomplete;
    });
  }

  int countFullyVaccinatedChildren(List<UserData> userData) {
    return userData
        .expand((user) => user.children)
        .where((child) => [
              child.vaccines.bcgVaccine,
              child.vaccines.hepaVaccine,
              child.vaccines.opv1Vaccine,
              child.vaccines.opv2Vaccine,
              child.vaccines.opv3Vaccine,
              child.vaccines.ipv1Vaccine,
              child.vaccines.ipv2Vaccine,
              child.vaccines.penta1Vaccine,
              child.vaccines.penta2Vaccine,
              child.vaccines.penta3Vaccine,
              child.vaccines.pcv1Vaccine,
              child.vaccines.pcv2Vaccine,
              child.vaccines.pcv3Vaccine,
              child.vaccines.mmrVaccine,
            ].every((vaccine) => vaccine == 'Yes'))
        .length;
  }

  int countIncompleteVaccinatedChildren(List<UserData> userData) {
    return userData
        .expand((user) => user.children)
        .where((child) => [
              child.vaccines.bcgVaccine,
              child.vaccines.hepaVaccine,
              child.vaccines.opv1Vaccine,
              child.vaccines.opv2Vaccine,
              child.vaccines.opv3Vaccine,
              child.vaccines.ipv1Vaccine,
              child.vaccines.ipv2Vaccine,
              child.vaccines.penta1Vaccine,
              child.vaccines.penta2Vaccine,
              child.vaccines.penta3Vaccine,
              child.vaccines.pcv1Vaccine,
              child.vaccines.pcv2Vaccine,
              child.vaccines.pcv3Vaccine,
              child.vaccines.mmrVaccine,
            ].any((vaccine) => vaccine == 'Yes'))
        .length;
  }

  int countChildrenWithVaccine(List<UserData> userData, String vaccineKey) {
    return userData.expand((user) => user.children).where((child) {
      final vaccines = child.vaccines;
      final vaccineMap = {
        "BCG": vaccines.bcgVaccine,
        "Hepatitis B": vaccines.hepaVaccine,
        "OPV1": vaccines.opv1Vaccine,
        "OPV2": vaccines.opv2Vaccine,
        "OPV3": vaccines.opv3Vaccine,
        "IPV1": vaccines.ipv1Vaccine,
        "IPV2": vaccines.ipv2Vaccine,
        "Pentavalent 1": vaccines.penta1Vaccine,
        "Pentavalent 2": vaccines.penta2Vaccine,
        "Pentavalent 3": vaccines.penta3Vaccine,
        "PCV1": vaccines.pcv1Vaccine,
        "PCV2": vaccines.pcv2Vaccine,
        "PCV3": vaccines.pcv3Vaccine,
        "MMR": vaccines.mmrVaccine,
      };

      if (vaccineKey == 'OPV') {
        return vaccineMap['OPV1'] == "Yes" &&
            vaccineMap['OPV2'] == "Yes" &&
            vaccineMap['OPV3'] == "Yes";
      } else if (vaccineKey == 'IPV') {
        return vaccineMap['IPV1'] == "Yes" && vaccineMap['IPV2'] == "Yes";
      } else if (vaccineKey == 'PCV') {
        return vaccineMap['PCV1'] == "Yes" &&
            vaccineMap['PCV2'] == "Yes" &&
            vaccineMap['PCV3'] == "Yes";
      } else if (vaccineKey == 'Pentavalent') {
        return vaccineMap['Pentavalent 1'] == "Yes" &&
            vaccineMap['Pentavalent 2'] == "Yes" &&
            vaccineMap['Pentavalent 3'] == "Yes";
      } else {
        return vaccineMap[vaccineKey] == "Yes";
      }
    }).length;
  }

  int countChildrenWithIncompleteVaccine(
      List<UserData> userData, String vaccineKey) {
    return userData.expand((user) => user.children).where((child) {
      final vaccines = child.vaccines;
      final vaccineMap = {
        "BCG": vaccines.bcgVaccine,
        "Hepatitis B": vaccines.hepaVaccine,
        "OPV1": vaccines.opv1Vaccine,
        "OPV2": vaccines.opv2Vaccine,
        "OPV3": vaccines.opv3Vaccine,
        "IPV1": vaccines.ipv1Vaccine,
        "IPV2": vaccines.ipv2Vaccine,
        "Pentavalent 1": vaccines.penta1Vaccine,
        "Pentavalent 2": vaccines.penta2Vaccine,
        "Pentavalent 3": vaccines.penta3Vaccine,
        "PCV1": vaccines.pcv1Vaccine,
        "PCV2": vaccines.pcv2Vaccine,
        "PCV3": vaccines.pcv3Vaccine,
        "MMR": vaccines.mmrVaccine,
      };

      if (vaccineKey == 'OPV') {
        return vaccineMap['OPV1'] == "Yes" ||
            vaccineMap['OPV2'] == "Yes" ||
            vaccineMap['OPV3'] == "Yes";
      } else if (vaccineKey == 'IPV') {
        return vaccineMap['IPV1'] == "Yes" || vaccineMap['IPV2'] == "Yes";
      } else if (vaccineKey == 'PCV') {
        return vaccineMap['PCV1'] == "Yes" ||
            vaccineMap['PCV2'] == "Yes" ||
            vaccineMap['PCV3'] == "Yes";
      } else if (vaccineKey == 'Pentavalent') {
        return vaccineMap['Pentavalent 1'] == "Yes" ||
            vaccineMap['Pentavalent 2'] == "Yes" ||
            vaccineMap['Pentavalent 3'] == "Yes";
      } else {
        return false;
      }
    }).length;
  }
}
