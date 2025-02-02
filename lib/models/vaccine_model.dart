import 'package:flutter/material.dart';

class VaccineData extends ChangeNotifier {
  List<VaccineModel> vaccines;

  VaccineData(this.vaccines);

  void addVaccines(VaccineModel vaccine) {
    vaccines.add(vaccine);
    notifyListeners();
  }

  void reset() {
    vaccines.clear();
    notifyListeners();
  }
}

class VaccineModel {
  String vaccineName;
  String stockCount;

  VaccineModel(this.vaccineName, this.stockCount);
}
