import 'package:flutter/foundation.dart';

class Schedules extends ChangeNotifier {
  List<ScheduleModel> schedules;

  Schedules(this.schedules);

  void addSchedules(ScheduleModel sched) {
    schedules.add(sched);
    notifyListeners();
  }

  void reset() {
    schedules.clear();
    notifyListeners();
  }
}

class ScheduleModel {
  final String schedID;
  final String childID;
  final String childName;
  final String parent;
  final String schedStatus;
  final DateTime schedDate;
  final String vaccineType;

  ScheduleModel(
      {required this.schedID,
      required this.childID,
      required this.childName,
      required this.parent,
      required this.schedStatus,
      required this.schedDate,
      required this.vaccineType});
}
