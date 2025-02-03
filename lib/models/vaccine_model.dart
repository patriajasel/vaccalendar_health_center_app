import 'package:flutter/material.dart';

class VaccineDetails extends ChangeNotifier {
  List<VaccineModel> vaccines;

  VaccineDetails(this.vaccines);

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
  int stockCount;

  VaccineModel(this.vaccineName, this.stockCount);
}
