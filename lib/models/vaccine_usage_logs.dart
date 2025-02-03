import 'package:flutter/material.dart';

class VaccineUsageLogs extends ChangeNotifier {
  List<VaccineLog> vaccineLogs;

  VaccineUsageLogs(this.vaccineLogs);

  void addVaccineLogs(VaccineLog log) {
    vaccineLogs.add(log);
    notifyListeners();
  }

  void reset() {
    vaccineLogs.clear();
    notifyListeners();
  }
}

class VaccineLog {
  DateTime time;
  String workerID;
  String workerName;
  String action;

  VaccineLog(this.time, this.workerID, this.workerName, this.action);
}
