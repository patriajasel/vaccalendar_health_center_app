import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchfield/searchfield.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class RegisterNewChild extends ConsumerStatefulWidget {
  const RegisterNewChild({super.key});

  @override
  ConsumerState<RegisterNewChild> createState() => _RegisterNewChildState();
}

class _RegisterNewChildState extends ConsumerState<RegisterNewChild> {
  final parentID = TextEditingController();
  final parentName = TextEditingController();

  List<String> gender = ['Male', 'Female'];
  String? parentGender = 'Male';

  List<Map<String, dynamic>> childData = [];
  final Map<String, Map<String, TextEditingController>> controllers = {};
  final Map<String, Map<String, String>> selectedGender = {};
  final uuid = Uuid();

  List<String> vaccines = [
    'BCG',
    'Hepatitis B',
    'OPV1',
    'OPV2',
    "OPV3",
    'IPV1',
    'IPV2',
    'PCV1',
    'PCV2',
    'PCV3',
    'Pentavalent 1',
    'Pentavalent 2',
    'Pentavalent 3',
    'MMR'
  ];

  @override
  void dispose() {
    super.dispose();
    for (var childControllers in controllers.values) {
      for (var controller in childControllers.values) {
        controller.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);
    final isLoading = ref.watch(isLoadingProvider);

    final userData = ref.watch(userDataProvider);

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
                "Register New Child Window",
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.025),
                  Container(
                    width: 500,
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.cyan, width: 2)),
                    child: SearchField<UserData>(
                        hint: 'Search...',
                        searchInputDecoration: SearchInputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                        maxSuggestionsInViewPort: 5,
                        textInputAction: TextInputAction.next,
                        onSuggestionTap: (selectedItem) {
                          setState(() {
                            parentID.text = selectedItem.item!.userID;
                            parentName.text = selectedItem.item!.parentName;
                          });
                        },
                        suggestions: userData.usersData.map((users) {
                          return SearchFieldListItem<UserData>(
                            users.parentName,
                            item: users,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.01),
                                  child: Text(
                                    users.parentName,
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
                                    users.userID,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList()),
                  ),
                  SizedBox(
                    width: screenWidth * 0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Parent Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Hahmlet',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    controller: parentID,
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.remember_me),
                      label: Text("Parent's ID"),
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
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    controller: parentName,
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      label: Text("Parent's Full Name"),
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
                  SizedBox(width: screenWidth * 0.01),
                  SizedBox(height: screenHeight * 0.025),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Child Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Hahmlet',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  fixedSize: Size(
                                      screenWidth * 0.07, screenHeight * 0.04),
                                  backgroundColor: Colors.cyan,
                                  foregroundColor: Colors.white),
                              onPressed: () {
                                setState(() {
                                  addChild();
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  Spacer(),
                                  Text('Add Child'),
                                ],
                              ))
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Column(
                        children: childData.map((child) {
                          return Column(
                            children: [
                              Row(
                                key: ValueKey(child['id']),
                                children: [
                                  Text(
                                    child['name'],
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'SourGummy',
                                        color: Colors.blueGrey),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    style: IconButton.styleFrom(
                                        backgroundColor: Colors.cyan),
                                    onPressed: () {
                                      setState(() {
                                        removeChild(child['id']);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controllers[child['id']]
                                          ?['childName'],
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Expanded(
                                    child: TextField(
                                      controller: controllers[child['id']]
                                          ?['facilityNumber'],
                                      style: TextStyle(
                                        fontFamily: 'Hahmlet',
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                            Icons.medical_services_outlined),
                                        label: Text("Facility Number"),
                                        labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'SourGummy',
                                            color: Colors.blueGrey),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controllers[child['id']]
                                          ?['childAge'],
                                      style: TextStyle(
                                        fontFamily: 'Hahmlet',
                                      ),
                                      decoration: InputDecoration(
                                        label: Text("Age"),
                                        labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'SourGummy',
                                            color: Colors.blueGrey),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: DropdownButtonFormField(
                                        value: selectedGender[child['id']]
                                            ?['selectedGender'],
                                        items: gender
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            selectedGender[child['id']] = {
                                              'selectedGender': val as String
                                            };
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
                                          labelText: "Gender",
                                          labelStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2.0,
                                              fontFamily: "SourGummy"),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.cyan.shade300,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.cyan.shade400,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controllers[child['id']]
                                          ?['birthdate'],
                                      readOnly: true,
                                      style: TextStyle(
                                        fontFamily: 'Hahmlet',
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.cake),
                                        suffixIcon: IconButton(
                                            onPressed: () => _selectDate(
                                                context,
                                                controllers[child['id']]![
                                                    'birthdate']!),
                                            icon: Icon(Icons.calendar_month)),
                                        label: Text("Birthday"),
                                        labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'SourGummy',
                                            color: Colors.blueGrey),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Expanded(
                                    child: TextField(
                                      controller: controllers[child['id']]
                                          ?['birthplace'],
                                      style: TextStyle(
                                        fontFamily: 'Hahmlet',
                                      ),
                                      decoration: InputDecoration(
                                        label: Text("Place of Birth"),
                                        labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'SourGummy',
                                            color: Colors.blueGrey),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controllers[child['id']]
                                          ?['childHeight'],
                                      style: TextStyle(
                                        fontFamily: 'Hahmlet',
                                      ),
                                      decoration: InputDecoration(
                                        label: Text("Height"),
                                        labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'SourGummy',
                                            color: Colors.blueGrey),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Expanded(
                                    child: TextField(
                                      controller: controllers[child['id']]
                                          ?['childWeight'],
                                      style: TextStyle(
                                        fontFamily: 'Hahmlet',
                                      ),
                                      decoration: InputDecoration(
                                        label: Text("Weight"),
                                        labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'SourGummy',
                                            color: Colors.blueGrey),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              SizedBox(
                                child: TextField(
                                  controller: controllers[child['id']]
                                      ?['childConditions'],
                                  style: TextStyle(
                                    fontFamily: 'Hahmlet',
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.home),
                                    label: Text(
                                        "Child Conditions (please separate it by a comma (,) )"),
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'SourGummy',
                                        color: Colors.blueGrey),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.cyan, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.cyan, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              Text(
                                'Child Vaccine Details',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'SourGummy',
                                    color: Colors.black),
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: vaccines.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 20,
                                          mainAxisExtent: screenHeight * 0.1,
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Text(
                                          "Has the child taken ${vaccines[index]} Vaccine?",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'SourGummy',
                                              color: Colors.black),
                                        ),
                                        TextField(
                                          controller: controllers[child['id']]![
                                              '${vaccines[index]} VaccineDate']!,
                                          readOnly: true,
                                          style: TextStyle(
                                            fontFamily: 'Hahmlet',
                                          ),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () => _selectDate(
                                                    context,
                                                    controllers[child['id']]![
                                                        '${vaccines[index]} VaccineDate']!),
                                                icon:
                                                    Icon(Icons.calendar_month)),
                                            label: Text("Date Taken"),
                                            labelStyle: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'SourGummy',
                                                color: Colors.blueGrey),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.cyan,
                                                    width: 2)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.cyan,
                                                    width: 2)),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                              Divider(
                                thickness: 2,
                                color: Colors.blueGrey,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
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
                  if (childData.isNotEmpty) {
                    if (parentID.text.isEmpty && parentName.text.isEmpty) {
                      if (context.mounted) {
                        showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                                message: "No parent have been selected!"));
                      }
                    } else {
                      for (var data in childData) {
                        bool isValidated =
                            validateTextFields(controllers[data['id']]!);

                        if (isValidated) {
                          String childID = generateChildID();
                          await FirebaseFirestoreServices().registerNewChild(
                              parentID.text, childID, controllers[data['id']]!);

                          if (context.mounted) {
                            showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                    message: "Child registered successfully!"));

                            Navigator.pop(context);
                          }
                        } else {
                          showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.error(
                                  message: "Some fields are empty"));
                        }
                      }
                    }
                  } else {
                    if (context.mounted) {
                      showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                              message:
                                  "You have not entered any child details yet"));
                    }
                  }
                },
                child: Text(
                  "Register User",
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

  String generateChildID() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const length = 7;
    final random = Random();

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
  }

  bool validateTextFields(Map<String, TextEditingController> controllers) {
    if (controllers['childName']!.text.isEmpty ||
        controllers['childAge']!.text.isEmpty ||
        controllers['childHeight']!.text.isEmpty ||
        controllers['childWeight']!.text.isEmpty ||
        controllers['birthdate']!.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController dateController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void addChild() {
    setState(() {
      String id = uuid.v4();
      childData.add({'id': id, 'name': 'Child ${childData.length + 1}'});

      // Initialize controllers for each child
      controllers[id] = {
        'childName': TextEditingController(),
        'facilityNumber': TextEditingController(),
        'childAge': TextEditingController(),
        'childGender': TextEditingController(),
        'childHeight': TextEditingController(),
        'childWeight': TextEditingController(),
        'birthdate': TextEditingController(),
        'birthplace': TextEditingController(),
        'childConditions': TextEditingController(),
        'BCG VaccineDate': TextEditingController(),
        'Hepatitis B VaccineDate': TextEditingController(),
        'OPV1 VaccineDate': TextEditingController(),
        'OPV2 VaccineDate': TextEditingController(),
        'OPV3 VaccineDate': TextEditingController(),
        'IPV1 VaccineDate': TextEditingController(),
        'IPV2 VaccineDate': TextEditingController(),
        'PCV1 VaccineDate': TextEditingController(),
        'PCV2 VaccineDate': TextEditingController(),
        'PCV3 VaccineDate': TextEditingController(),
        'Pentavalent 1 VaccineDate': TextEditingController(),
        'Pentavalent 2 VaccineDate': TextEditingController(),
        'Pentavalent 3 VaccineDate': TextEditingController(),
        'MMR VaccineDate': TextEditingController(),
      };

      selectedGender[id] = {'selectedGender': 'Male'};
    });
  }

  void removeChild(String id) {
    setState(() {
      // Dispose controllers
      controllers[id]?.values.forEach((controller) => controller.dispose());
      controllers.remove(id);
      selectedGender.remove(id);
      childData.removeWhere((item) => item['id'] == id);
    });
  }
}
