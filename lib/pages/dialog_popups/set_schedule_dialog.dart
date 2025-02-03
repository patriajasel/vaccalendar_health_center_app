import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchfield/searchfield.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:vaccalendar_health_center_app/models/child_model.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class SetScheduleDialog extends ConsumerStatefulWidget {
  const SetScheduleDialog({super.key});

  @override
  ConsumerState<SetScheduleDialog> createState() => _SetScheduleDialogState();
}

class _SetScheduleDialogState extends ConsumerState<SetScheduleDialog> {
  final childController = TextEditingController();
  final childIDController = TextEditingController();
  final parentController = TextEditingController();
  final dateController = TextEditingController();

  String? selectedVaccine;

  final List<String> vaccines = [
    'BCG',
    'OPV1',
    'PCV1',
    'Pentavalent 1st Dose',
    'Hepatitis B',
    'OPV2',
    'PCV2',
    'Pentavalent 2nd Dose',
    'IPV1',
    'OPV3',
    'PCV3',
    'Pentavalent 3rd Dose',
    'IPV2',
    'MMR',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);
    final isLoading = ref.watch(isLoadingProvider);

    final childData = ref.watch(childDataProvider);

    return Stack(
      children: [
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        AlertDialog(
          backgroundColor: Colors.cyan.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.cyan, width: 2)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Vaccination Schedule Window",
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
            height: screenHeight * 0.6,
            width: screenWidth * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Select a Patient or Child",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'SourGummy',
                      color: Colors.blueGrey),
                ),
                Container(
                  width: 500,
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.cyan, width: 2)),
                  child: SearchField<ChildModel>(
                      hint: 'Search...',
                      searchInputDecoration: SearchInputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      maxSuggestionsInViewPort: 5,
                      textInputAction: TextInputAction.next,
                      onSuggestionTap: (selectedItem) {
                        setState(() {
                          childController.text = selectedItem.item!.childName;
                          childIDController.text = selectedItem.item!.childID;
                          parentController.text = selectedItem.item!.parent;
                        });
                      },
                      suggestions: childData.children.map((child) {
                        return SearchFieldListItem<ChildModel>(
                          child.childName,
                          item: child,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.01),
                                child: Text(
                                  child.childName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  child.childID,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  child.parent,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()),
                ),
                SizedBox(height: screenHeight * 0.025),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: childIDController,
                        style: TextStyle(
                          fontFamily: 'Hahmlet',
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.remember_me),
                          label: Text("Child ID"),
                          labelStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SourGummy',
                              color: Colors.blueGrey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Expanded(
                      child: TextField(
                        controller: childController,
                        style: TextStyle(
                          fontFamily: 'Hahmlet',
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.child_care),
                          label: Text("Child Name"),
                          labelStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SourGummy',
                              color: Colors.blueGrey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                  ],
                ),
                SizedBox(height: screenHeight * 0.025),
                SizedBox(
                  width: screenWidth * 0.2,
                  child: TextField(
                    controller: parentController,
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervisor_account),
                      label: Text("Parent Name"),
                      labelStyle: TextStyle(
                          fontSize: 18,
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
                ),
                SizedBox(height: screenHeight * 0.025),
                SizedBox(
                  width: screenWidth * 0.2,
                  child: TextField(
                    controller: dateController,
                    readOnly: true, // Prevent manual input
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                      label: Text("Select Date"),
                      labelStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SourGummy',
                          color: Colors.blueGrey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.cyan, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.cyan, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  'Please select your vaccine:',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'SourGummy',
                      color: Colors.blueGrey),
                ),
                SizedBox(height: screenHeight * 0.01),
                Expanded(
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    childAspectRatio:
                        4, // Controls height and width of each item (adjust as needed)
                    children: List.generate(vaccines.length, (index) {
                      return RadioListTile<String>(
                        activeColor: Colors.cyan,
                        title: Text(
                          vaccines[index],
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Hahmlet',
                              color: Colors.black),
                        ),
                        value: vaccines[index],
                        groupValue: selectedVaccine,
                        onChanged: (String? value) {
                          setState(() {
                            selectedVaccine = value;
                          });
                        },
                      );
                    }),
                  ),
                ),
                if (selectedVaccine != null)
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    child: Text(
                      'Selected vaccine: $selectedVaccine Vaccine',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SourGummy',
                          color: Colors.blueGrey),
                    ),
                  )
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size(screenWidth * 0.1, screenHeight * 0.04),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
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
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  ref.read(isLoadingProvider.notifier).state =
                      true; // set  loading animation to true

                  final String schedStats =
                      'Pending'; // default schedule status

                  bool isVaccineTaken = await FirebaseFirestoreServices()
                      .checkIfVaccineTaken(
                          selectedVaccine!, childIDController.text);

                  if (isVaccineTaken) {
                    if (context.mounted) {
                      showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                              message:
                                  "Child has already taken the vaccine. Setting vaccination schedule failed"));
                    }
                  } else {
                    // Creating new schedule on Firestore
                    if (dateController.text.isEmpty) {
                      if (context.mounted) {
                        showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                                message: "Date for the vaccination is empty!"));
                      }
                    } else {
                      await FirebaseFirestoreServices().setNewSchedule(
                          ref,
                          childIDController.text,
                          childController.text,
                          parentController.text,
                          DateTime.parse(dateController.text),
                          selectedVaccine!,
                          schedStats);

                      await FirebaseFirestoreServices().obtainAllSchedules(ref);

                      if (context.mounted) {
                        showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.success(
                                message:
                                    "Setting vaccination schedule success!"));
                      }

                      if (context.mounted) {
                        ref.read(isLoadingProvider.notifier).state = false;
                        Navigator.pop(context); // Removing the popup window
                      }
                    }
                  }
                },
                child: Text(
                  "Set Schedule",
                  style: TextStyle(
                      fontFamily: 'Hahmlet',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
        print(dateController.text);
      });
    }
  }
}
