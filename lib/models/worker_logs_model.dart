import 'package:flutter/material.dart';

class WorkerLogs extends ChangeNotifier {
  List<WorkerLogsModel> logs;

  WorkerLogs(this.logs);

  void addLogs(WorkerLogsModel log) {
    logs.add(log);
    notifyListeners();
  }

  void reset() {
    logs.clear();
    notifyListeners();
  }
}

class WorkerLogsModel {
  String workerID;
  String workerName;
  DateTime dateTime;
  String actions;

  WorkerLogsModel(this.workerID, this.workerName, this.dateTime, this.actions);
}
