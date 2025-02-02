import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class VaccineInventory extends ConsumerStatefulWidget {
  const VaccineInventory({super.key});

  @override
  ConsumerState<VaccineInventory> createState() => _VaccineInventoryState();
}

class _VaccineInventoryState extends ConsumerState<VaccineInventory> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    List<String> vaccineImages = [
      'lib/assets/images/vaccines/bcg_vaccine.jpg',
      'lib/assets/images/vaccines/hepatitis_b_vaccine.jpg',
      'lib/assets/images/vaccines/ipv_vaccine.jpg',
      'lib/assets/images/vaccines/mmr_vaccine.jpg',
      'lib/assets/images/vaccines/opv_vaccine.jpg',
      'lib/assets/images/vaccines/pcv_vaccine.jpg',
      'lib/assets/images/vaccines/pentavalent_vaccine.jpg',
    ];

    List<String> vaccineNames = [
      'BCG',
      'Hepatitis B',
      'IPV',
      'MMR',
      'OPV',
      'PCV',
      'Pentavalent'
    ];

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
                    itemCount: vaccineImages.length,
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
                                    "${vaccineNames[index]} Vaccine",
                                    style: TextStyle(
                                        fontFamily: 'Hahmlet',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    "Number of Stock: 100",
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
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          )),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      IconButton(
                                          style: IconButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              elevation: 10),
                                          onPressed: () {},
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
              height: screenHeight * 0.01,
            )
          ],
        ),
      ),
    );
  }
}
