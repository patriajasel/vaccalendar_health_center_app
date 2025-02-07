import 'package:flutter/material.dart';

class Workers extends ChangeNotifier {
  List<WorkerModel> workers;

  Workers(this.workers);

  void addWorker(WorkerModel worker) {
    workers.add(worker);
    notifyListeners();
  }

  void reset() {
    workers.clear();
    notifyListeners();
  }
}

class WorkerModel {
  String workerID;
  String surname;
  String firstname;
  String middlename;
  int age;
  DateTime birthdate;
  String gender;
  String address;
  String contactNumber;
  String emailAddress;
  String position;
  String loginCodes;
  DateTime? whenCodeGenerated;

  WorkerModel(
      this.workerID,
      this.surname,
      this.firstname,
      this.middlename,
      this.age,
      this.birthdate,
      this.gender,
      this.address,
      this.contactNumber,
      this.emailAddress,
      this.position,
      this.loginCodes,
      this.whenCodeGenerated);
}
