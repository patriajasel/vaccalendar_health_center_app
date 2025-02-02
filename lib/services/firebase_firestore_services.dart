// ignore_for_file: avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/models/child_model.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class FirebaseFirestoreServices {
  final users = FirebaseFirestore.instance.collection('users');
  final schedules = FirebaseFirestore.instance.collection('schedules');

  Future<void> obtainAllNeededData(WidgetRef ref) async {
    await obtainAllChildData(ref);
    await obtainAllSchedules(ref);
    await obtainAllUsers(ref);
  }

  //* ***********************************  *//
  //* METHODS FOR AUTHENTICATION PURPOSES  *//
  //* ***********************************  *//

  Future<bool> checkUserRoleWindows(String userID) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("userRoles")
          .doc(userID)
          .get();

      if (snapshot.exists) {
        String role = snapshot.get("user_role");

        if (role == "admin") {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("Error checking user role: $e");
    }
    return false;
  }

  Future<bool> checkUserRoleAndroid(String userID) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("userRoles")
          .doc(userID)
          .get();

      if (snapshot.exists) {
        String role = snapshot.get("user_role");

        if (role == "worker") {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("Error checking user role: $e");
    }
    return false;
  }

  //* ************** *//
  //* END OF METHODS *//
  //* ************** *//

  //* ******************************* *//
  //* METHODS FOR OBTAINING ALL DATA  *//
  //* ******************************* *//

  Future<void> obtainAllChildData(WidgetRef ref) async {
    Future.microtask(() {
      ref.read(childDataProvider.notifier).reset();
    });
    try {
      QuerySnapshot userDocs = await users.get();

      for (var doc in userDocs.docs) {
        print("Document: ${doc.id}");

        final parentData = doc.data() as Map<String, dynamic>;
        QuerySnapshot childDocs = await doc.reference.collection('child').get();

        for (var child in childDocs.docs) {
          final childData = child.data() as Map<String, dynamic>;

          ref.read(childDataProvider.notifier).addChild(ChildModel(
              parent:
                  "${parentData['guardian_firstName']} ${parentData['guardian_surname']} ",
              childName: childData['child_nickname'],
              childID: child.id,
              childConditions:
                  List<String>.from(childData['child_conditions'])));
        }
      }
    } catch (e, stacktrace) {
      print("Error getting all child data: $e");
      print(stacktrace);
    }
  }

  Future<void> obtainAllUsers(WidgetRef ref) async {
    Future.microtask(() {
      ref.read(userDataProvider.notifier).reset();
    });
    try {
      QuerySnapshot userDocs = await users.get();

      for (var doc in userDocs.docs) {
        final userID = doc.id;
        final parentData = doc.data() as Map<String, dynamic>;

        List<ChildrenData> children = [];

        QuerySnapshot child = await doc.reference.collection('child').get();

        for (var childDoc in child.docs) {
          final childID = childDoc.id;
          final childData = childDoc.data() as Map<String, dynamic>;

          VaccineData? vaccines;

          QuerySnapshot vaccine =
              await childDoc.reference.collection('vaccines').get();

          for (var vaccineDoc in vaccine.docs) {
            final vaccineData = vaccineDoc.data() as Map<String, dynamic>;

            vaccines = VaccineData(
              bcgVaccine: vaccineData['bcg_vaccine'],
              bcgDate: vaccineData['bcg_vaccine_date'] != null
                  ? (vaccineData['bcg_vaccine_date'] as Timestamp).toDate()
                  : null,
              hepaVaccine: vaccineData['hepatitisB_vaccine'],
              hepaDate: vaccineData['hepatitisB_vaccine_date'] != null
                  ? (vaccineData['hepatitisB_vaccine_date'] as Timestamp)
                      .toDate()
                  : null,
              ipv1Vaccine: vaccineData['ipv1_vaccine'],
              ipv1Date: vaccineData['ipv1_vaccine_date'] != null
                  ? (vaccineData['ipv1_vaccine_date'] as Timestamp).toDate()
                  : null,
              ipv2Vaccine: vaccineData['ipv2_vaccine'],
              ipv2Date: vaccineData['ipv2_vaccine_date'] != null
                  ? (vaccineData['ipv2_vaccine_date'] as Timestamp).toDate()
                  : null,
              mmrVaccine: vaccineData['mmr_vaccine'],
              mmrDate: vaccineData['mmr_vaccine_date'] != null
                  ? (vaccineData['mmr_vaccine_date'] as Timestamp).toDate()
                  : null,
              opv1Vaccine: vaccineData['opv1_vaccine'],
              opv1Date: vaccineData['opv1_vaccine_date'] != null
                  ? (vaccineData['opv1_vaccine_date'] as Timestamp).toDate()
                  : null,
              opv2Vaccine: vaccineData['opv2_vaccine'],
              opv2Date: vaccineData['opv2_vaccine_date'] != null
                  ? (vaccineData['opv2_vaccine_date'] as Timestamp).toDate()
                  : null,
              opv3Vaccine: vaccineData['opv3_vaccine'],
              opv3Date: vaccineData['opv3_vaccine_date'] != null
                  ? (vaccineData['opv3_vaccine_date'] as Timestamp).toDate()
                  : null,
              pcv1Vaccine: vaccineData['pcv1_vaccine'],
              pcv1Date: vaccineData['pcv1_vaccine_date'] != null
                  ? (vaccineData['pcv1_vaccine_date'] as Timestamp).toDate()
                  : null,
              pcv2Vaccine: vaccineData['pcv2_vaccine'],
              pcv2Date: vaccineData['pcv2_vaccine_date'] != null
                  ? (vaccineData['pcv2_vaccine_date'] as Timestamp).toDate()
                  : null,
              pcv3Vaccine: vaccineData['pcv3_vaccine'],
              pcv3Date: vaccineData['pcv3_vaccine_date'] != null
                  ? (vaccineData['pcv3_vaccine_date'] as Timestamp).toDate()
                  : null,
              penta1Vaccine: vaccineData['pentavalent1_vaccine'],
              penta1Date: vaccineData['pentavalent1_vaccine_date'] != null
                  ? (vaccineData['pentavalent1_vaccine_date'] as Timestamp)
                      .toDate()
                  : null,
              penta2Vaccine: vaccineData['pentavalent2_vaccine'],
              penta2Date: vaccineData['pentavalent2_vaccine_date'] != null
                  ? (vaccineData['pentavalent2_vaccine_date'] as Timestamp)
                      .toDate()
                  : null,
              penta3Vaccine: vaccineData['pentavalent3_vaccine'],
              penta3Date: vaccineData['pentavalent3_vaccine_date'] != null
                  ? (vaccineData['pentavalent3_vaccine_date'] as Timestamp)
                      .toDate()
                  : null,
            );
          }

          children.add(ChildrenData(
              childID: childID,
              childName: childData['child_nickname'],
              facilityNumber: childData['facility_number'],
              childAge: childData['child_age'].toString(),
              childGender: childData['child_gender'],
              birthdate: (childData['child_birthdate'] as Timestamp).toDate(),
              birthplace: childData['child_birthplace'],
              childHeight: childData['child_height'].toString(),
              childWeight: childData['child_weight'].toString(),
              childConditions: (childData['child_conditions'] as List<dynamic>)
                  .cast<String>(),
              vaccines: vaccines));
        }

        final userData = UserData(
            userID: userID,
            parentName:
                '${parentData['guardian_firstName']} ${parentData['guardian_middleName']} ${parentData['guardian_surname']}',
            parentAge: parentData['guardian_age'],
            parentGender: parentData['guardian_gender'],
            email: parentData['guardian_email'],
            number: parentData['guardian_contact'],
            address: parentData['guardian_address'],
            children: children);

        ref.read(userDataProvider.notifier).addUsers(userData);
      }
    } catch (e, stacktrace) {
      print("Error getting all child data: $e");
      print(stacktrace);
    }
  }

  //* ************** *//
  //* END OF METHODS *//
  //* ************** *//

  //* *******************************  *//
  //* METHODS FOR SCHEDULING PURPOSES  *//
  //* *******************************  *//

  // Getting all the schedules in firebase

  Future<void> obtainAllSchedules(WidgetRef ref) async {
    Future.microtask(() {
      ref.read(scheduleDataProvider.notifier).reset();
    });
    try {
      final schedule = await schedules.get();

      for (var sched in schedule.docs) {
        final schedData = sched.data();
        final scheduleDate = (schedData['schedule_date'] as Timestamp).toDate();
        final currentDate = DateTime.now();

        if (scheduleDate.year > currentDate.year ||
            (scheduleDate.year == currentDate.year &&
                scheduleDate.month > currentDate.month) ||
            (scheduleDate.year == currentDate.year &&
                scheduleDate.month == currentDate.month &&
                scheduleDate.day >= currentDate.day)) {
          print(DateTime.now());
          ref.read(scheduleDataProvider.notifier).addSchedules(ScheduleModel(
                schedID: sched.id,
                childID: schedData['child_id'],
                childName: schedData['child_name'],
                parent: schedData['parent'],
                schedStatus: schedData['schedule_status'],
                schedDate: (schedData['schedule_date'] as Timestamp).toDate(),
                vaccineType: schedData['vaccine_type'],
              ));
        } else {
          if (schedData['schedule_status'] == 'Pending') {
            await schedules.doc(sched.id).update({
              'schedule_status': 'Overdue',
            });

            ref.read(scheduleDataProvider.notifier).addSchedules(ScheduleModel(
                  schedID: sched.id,
                  childID: schedData['child_id'],
                  childName: schedData['child_name'],
                  parent: schedData['parent'],
                  schedStatus: 'Overdue',
                  schedDate: (schedData['schedule_date'] as Timestamp).toDate(),
                  vaccineType: schedData['vaccine_type'],
                ));
          } else {
            ref.read(scheduleDataProvider.notifier).addSchedules(ScheduleModel(
                  schedID: sched.id,
                  childID: schedData['child_id'],
                  childName: schedData['child_name'],
                  parent: schedData['parent'],
                  schedStatus: schedData['schedule_status'],
                  schedDate: (schedData['schedule_date'] as Timestamp).toDate(),
                  vaccineType: schedData['vaccine_type'],
                ));
          }
        }
      }
    } catch (e, stacktrace) {
      print("Error getting all schedules: $e");
      print(stacktrace);
    }
  }

  // Setting a new schedule

  Future<void> setNewSchedule(
      WidgetRef ref,
      String childID,
      String childName,
      String parent,
      DateTime dateSchedule,
      String vaccineType,
      String scheduleStatus) async {
    final date = DateFormat('yyyyMMdd').format(dateSchedule);
    late String scheduleID;
    bool scheduleExists = true;

    Map<String, dynamic> scheduleInfo = {
      'child_name': childName,
      'child_id': childID,
      'schedule_date': dateSchedule,
      'vaccine_type': vaccineType,
      'schedule_status': scheduleStatus,
      'parent': parent
    };

    try {
      while (scheduleExists) {
        final randomNumber = Random().nextInt(90000) + 10000;
        scheduleID = '$date$randomNumber';

        final docSnapshot = await schedules.doc(scheduleID).get();

        if (!docSnapshot.exists) {
          scheduleExists = false;
        }
      }

      await schedules.doc(scheduleID).set(scheduleInfo);
      ref.read(isLoadingProvider.notifier).state = false;
      print("Schedule set successfully with ID: $scheduleID");
    } catch (e) {
      print("Error setting new schedule: $e");
    }
  }

  // Updating the schedule status

  Future<void> updateScheduleStatus(
      String schedID, String updatedStatus) async {
    try {
      await schedules.doc(schedID).update({'schedule_status': updatedStatus});
    } catch (e) {
      print("Error updating schedule status: $e");
    }
  }

  // Updating child Vaccine Details

  Future<void> updateChildVaccineDetails(String childID, String status,
      DateTime dateFinished, String vaccineType) async {
    String vaccineField = getVaccineField(vaccineType);
    String vaccineDateField = getVaccineDateField(vaccineType);
    try {
      QuerySnapshot query = await users.get();

      for (var user in query.docs) {
        QuerySnapshot childVaccines = await user.reference
            .collection('child')
            .doc(childID)
            .collection('vaccines')
            .get();

        for (var vaccines in childVaccines.docs) {
          await vaccines.reference
              .update({vaccineField: status, vaccineDateField: dateFinished});
        }
      }
    } catch (e) {
      print("Error updating child vaccine data: $e");
    }
  }

  // Checking if child already has the vaccine

  Future<bool> checkIfVaccineTaken(String vaccineType, String childID) async {
    try {
      QuerySnapshot parent = await users.get();

      for (var parent in parent.docs) {
        QuerySnapshot child = await parent.reference
            .collection('child')
            .doc(childID)
            .collection('vaccines')
            .get();

        for (var vaccine in child.docs) {
          final vaccineData = vaccine.data() as Map<String, dynamic>;
          final type = getVaccineField(vaccineType);
          if (vaccineData[type] == 'Yes') {
            return true;
          } else {
            return false;
          }
        }
      }
    } catch (e) {
      print("Error checking child's vaccine history");
    }
    return false;
  }

  //* ************** *//
  //* END OF METHODS *//
  //* ************** *//

  //* *******************************  *//
  //* FOR ADDING NEW CHILD PURPOSES    *//
  //* *******************************  *//

  Future<void> registerNewChild(String userID, String childID,
      Map<String, TextEditingController> controllers) async {
    try {
      List<String> childConditions =
          separateChildConditions(controllers['childConditions']!.text);

      Map<String, dynamic> childInfo = {
        'child_nickname': controllers['childName']!.text,
        'facility_number': controllers['facilityNumber']!.text,
        'child_age': controllers['childAge']!.text,
        'child_gender': controllers['childGender']!.text,
        'child_birthdate': controllers['birthdate']!.text,
        'child_birthplace': controllers['birthplace']!.text,
        'child_height': controllers['childHeight']!.text,
        'child_weight': controllers['childWeight']!.text,
        'child_conditions': childConditions.toList(),
        'image_url': ''
      };

      Map<String, dynamic> vaccineInfo = {
        'bcg_vaccine':
            controllers['BCG VaccineDate']!.text == '' ? 'No' : 'Yes',
        'bcg_vaccine_date': controllers['BCG VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['BCG VaccineDate']!.text),
        'hepatitisB_vaccine':
            controllers['Hepatitis B VaccineDate']!.text == '' ? 'No' : 'Yes',
        'hepatitisB_vaccine_date':
            controllers['Hepatitis B VaccineDate']!.text == ''
                ? null
                : DateTime.parse(controllers['Hepatitis B VaccineDate']!.text),
        'ipv1_vaccine':
            controllers['IPV1 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'ipv1_vaccine_date': controllers['IPV1 VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['IPV1 VaccineDate']!.text),
        'ipv2_vaccine':
            controllers['IPV2 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'ipv2_vaccine_date': controllers['IPV2 VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['IPV2 VaccineDate']!.text),
        'mmr_vaccine':
            controllers['MMR VaccineDate']!.text == '' ? 'No' : 'Yes',
        'mmr_vaccine_date': controllers['MMR VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['MMR VaccineDate']!.text),
        'opv1_vaccine':
            controllers['OPV1 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'opv1_vaccine_date': controllers['OPV1 VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['OPV1 VaccineDate']!.text),
        'opv2_vaccine':
            controllers['OPV2 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'opv2_vaccine_date': controllers['OPV2 VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['OPV2 VaccineDate']!.text),
        'opv3_vaccine':
            controllers['OPV3 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'opv3_vaccine_date': controllers['OPV3 VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['OPV3 VaccineDate']!.text),
        'pcv1_vaccine':
            controllers['PCV1 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'pcv1_vaccine_date': controllers['PCV1 VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['PCV1 VaccineDate']!.text),
        'pcv2_vaccine':
            controllers['PCV2 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'pcv2_vaccine_date': controllers['PCV2 VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['PCV2 VaccineDate']!.text),
        'pcv3_vaccine':
            controllers['PCV3 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'pcv3_vaccine_date': controllers['PCV3 VaccineDate']!.text == ''
            ? null
            : DateTime.parse(controllers['PCV3 VaccineDate']!.text),
        'pentavalent1_vaccine':
            controllers['Pentavalent 1 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'pentavalent1_vaccine_date': controllers['Pentavalent 1 VaccineDate']!
                    .text ==
                ''
            ? null
            : DateTime.parse(controllers['Pentavalent 1 VaccineDate']!.text),
        'pentavalent2_vaccine':
            controllers['Pentavalent 2 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'pentavalent2_vaccine_date': controllers['Pentavalent 2 VaccineDate']!
                    .text ==
                ''
            ? null
            : DateTime.parse(controllers['Pentavalent 2 VaccineDate']!.text),
        'pentavalent3_vaccine':
            controllers['Pentavalent 3 VaccineDate']!.text == '' ? 'No' : 'Yes',
        'pentavalent3_vaccine_date': controllers['Pentavalent 3 VaccineDate']!
                    .text ==
                ''
            ? null
            : DateTime.parse(controllers['Pentavalent 3 VaccineDate']!.text),
      };

      await users.doc(userID).collection('child').doc(childID).set(childInfo);

      await users
          .doc(userID)
          .collection('child')
          .doc(childID)
          .collection('vaccines')
          .add(vaccineInfo);
    } catch (e) {
      print("Error adding new child: $e");
    }
  }

  //* ************** *//
  //* END OF METHODS *//
  //* ************** *//

  //* *************  *//
  //* OTHER METHODS  *//
  //* *************  *//

  String getVaccineField(String vaccine) {
    switch (vaccine) {
      case 'BCG':
        return 'bcg_vaccine';
      case 'Hepatitis B':
        return 'hepatitisB_vaccine';
      case 'IPV1':
        return 'ipv1_vaccine';
      case 'IPV2':
        return 'ipv2_vaccine';
      case 'OPV1':
        return 'opv1_vaccine';
      case 'OPV2':
        return 'opv2_vaccine';
      case 'OPV3':
        return 'opv3_vaccine';
      case 'MMR':
        return 'mmr_vaccine';
      case 'PCV1':
        return 'pcv1_vaccine';
      case 'PCV2':
        return 'pcv2_vaccine';
      case 'PCV3':
        return 'pcv3_vaccine';
      case 'Pentavalent 1st Dose':
        return 'pentavalent1_vaccine';
      case 'Pentavalent 2nd Dose':
        return 'pentavalent2_vaccine';
      case 'Pentavalent 3rd Dose':
        return 'pentavalent3_vaccine';
      default:
        return 'vaccine-not-exist';
    }
  }

  String getVaccineDateField(String vaccine) {
    switch (vaccine) {
      case 'BCG':
        return 'bcg_vaccine_date';
      case 'Hepatitis B':
        return 'hepatitisB_vaccine_date';
      case 'IPV1':
        return 'ipv1_vaccine_date';
      case 'IPV2':
        return 'ipv2_vaccine_date';
      case 'OPV1':
        return 'opv1_vaccine_date';
      case 'OPV2':
        return 'opv2_vaccine_date';
      case 'OPV3':
        return 'opv3_vaccine_date';
      case 'MMR':
        return 'mmr_vaccine_date';
      case 'PCV1':
        return 'pcv1_vaccine_date';
      case 'PCV2':
        return 'pcv2_vaccine_date';
      case 'PCV3':
        return 'pcv3_vaccine_date';
      case 'Pentavalent 1st Dose':
        return 'pentavalent1_vaccine_date';
      case 'Pentavalent 2nd Dose':
        return 'pentavalent2_vaccine_date';
      case 'Pentavalent 3rd Dose':
        return 'pentavalent3_vaccine_date';
      default:
        return 'vaccine-not-exist';
    }
  }

  List<String> separateChildConditions(String childConditions) {
    List<String> conditions = childConditions.replaceAll(' ', '').split(',');
    return conditions;
  }

  //* ************** *//
  //* END OF METHODS *//
  //* ************** *//
}
