// ignore_for_file: avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/models/child_model.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class FirebaseFirestoreServices {
  final users = FirebaseFirestore.instance.collection('users');
  final schedules = FirebaseFirestore.instance.collection('schedules');

  Future<void> obtainAllNeededData(WidgetRef ref) async {
    await obtainAllChildData(ref);
    await obtainAllSchedules(ref);
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

  //* ************** *//
  //* END OF METHODS *//
  //* ************** *//
}
