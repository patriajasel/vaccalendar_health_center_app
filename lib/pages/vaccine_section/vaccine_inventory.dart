import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class VaccineInventory extends ConsumerStatefulWidget {
  const VaccineInventory({super.key});

  @override
  ConsumerState<VaccineInventory> createState() => _VaccineInventoryState();
}

class _VaccineInventoryState extends ConsumerState<VaccineInventory> {
  final stockNumber = TextEditingController();

  @override
  void dispose() {
    stockNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    List<String> vaccineImages = [
      'lib/assets/images/vaccines/opv_vaccine.jpg',
      'lib/assets/images/vaccines/pcv_vaccine.jpg',
      'lib/assets/images/vaccines/ipv_vaccine.jpg',
      'lib/assets/images/vaccines/bcg_vaccine.jpg',
      'lib/assets/images/vaccines/pentavalent_vaccine.jpg',
      'lib/assets/images/vaccines/mmr_vaccine.jpg',
      'lib/assets/images/vaccines/hepatitis_b_vaccine.jpg',
    ];

    final vaccineData = ref.watch(vaccineDataProvider).vaccines;

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
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.01),
              child: Text(
                "Vaccine Inventory",
                style: TextStyle(
                    fontFamily: 'SourGummy',
                    fontSize: 30,
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
            Expanded(
                child: ListView.builder(
                    itemCount: vaccineData.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                        ),
                        child: SizedBox(
                          height: screenHeight * 0.1,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                side: BorderSide(
                                  color: Colors.cyan,
                                  width: 2,
                                )),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.cyan, width: 2),
                                      borderRadius: BorderRadius.circular(15)),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.01,
                                      vertical: screenHeight * 0.01),
                                  child: ClipRRect(
                                    clipBehavior: Clip.antiAlias,
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      fit: BoxFit.cover,
                                      vaccineImages[index],
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Expanded(
                                    child: ListTile(
                                  title: Text(
                                    "${vaccineData[index].vaccineName} Vaccine",
                                    style: TextStyle(
                                        fontFamily: 'Hahmlet',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  trailing: Text(
                                    "Number of Stock: ${vaccineData[index].stockCount}",
                                    style: TextStyle(
                                        fontFamily: 'SourGummy',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey),
                                  ),
                                )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.01),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          style: IconButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              elevation: 10),
                                          onPressed: () {
                                            showAddRemoveDialog(
                                                'Add',
                                                context,
                                                vaccineData[index].vaccineName,
                                                vaccineData[index].stockCount,
                                                screenHeight,
                                                screenWidth);
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          )),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      IconButton(
                                          style: IconButton.styleFrom(
                                              disabledBackgroundColor:
                                                  Colors.grey,
                                              backgroundColor: Colors.red,
                                              elevation: 10),
                                          onPressed:
                                              vaccineData[index].stockCount == 0
                                                  ? null
                                                  : () {
                                                      showAddRemoveDialog(
                                                          'Remove',
                                                          context,
                                                          vaccineData[index]
                                                              .vaccineName,
                                                          vaccineData[index]
                                                              .stockCount,
                                                          screenHeight,
                                                          screenWidth);
                                                    },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
            SizedBox(
              height: screenHeight * 0.015,
            )
          ],
        ),
      ),
    );
  }

  void showAddRemoveDialog(
      String action,
      BuildContext context,
      String vaccineName,
      int numberStock,
      double screenHeight,
      double screenWidth) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.cyan.shade50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.cyan, width: 2)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$action Vaccines",
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
              height: screenHeight * 0.125,
              width: screenWidth * 0.2,
              child: Column(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "Vaccine Name: $vaccineName",
                        style: TextStyle(
                            fontFamily: 'Hahmlet',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      subtitle: Text(
                        'Number of Stocks: $numberStock',
                        style: TextStyle(
                            fontFamily: 'SourGummy',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  TextField(
                    controller: stockNumber,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vaccines),
                      label: Text(
                          "Please enter the amount you want to ${action.toLowerCase()}"),
                      labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'SourGummy',
                          color: Colors.blueGrey),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.cyan, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.cyan, width: 2)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(screenWidth * 0.1, screenHeight * 0.04),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  onPressed: () {
                    stockNumber.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: 'Hahmlet',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(screenWidth * 0.1, screenHeight * 0.04),
                      backgroundColor:
                          action == 'Add' ? Colors.green : Colors.red,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    if (action == "Add") {
                      final result = int.parse(stockNumber.text) + numberStock;

                      await FirebaseFirestoreServices()
                          .updateVaccineInventory(vaccineName, result, ref);

                      stockNumber.clear();

                      if (context.mounted) {
                        showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.success(
                                message: "$vaccineName vaccine stock updated"));
                        Navigator.pop(context);
                      }
                    } else {
                      if (int.parse(stockNumber.text) > numberStock) {
                        showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                                message:
                                    "The amount you've set is greater than the number of $vaccineName vaccine stock"));
                      } else {
                        final result =
                            numberStock - int.parse(stockNumber.text);

                        await FirebaseFirestoreServices()
                            .updateVaccineInventory(vaccineName, result, ref);

                        stockNumber.clear();

                        if (context.mounted) {
                          showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                  message:
                                      "$vaccineName vaccine stock updated"));
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  child: Text(action,
                      style: TextStyle(
                          fontFamily: 'Hahmlet',
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),
            ],
          );
        });
  }
}
