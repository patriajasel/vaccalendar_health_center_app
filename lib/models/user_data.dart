import 'package:flutter/material.dart';

class Users extends ChangeNotifier {
  final List<UserData> usersData;

  Users(this.usersData);

  void addUsers(UserData user) {
    usersData.add(user);
    notifyListeners();
  }

  void reset() {
    usersData.clear();
    notifyListeners();
  }
}

class UserData {
  final String userID;
  final String parentName;
  final int parentAge;
  final String parentGender;
  final String email;
  final String number;
  final String address;
  final List<ChildrenData> children;

  UserData(
      {this.userID = '',
      this.parentName = '',
      this.parentAge = 0,
      this.parentGender = '',
      this.email = '',
      this.number = '',
      this.address = '',
      required this.children});
}

class ChildrenData {
  final String childID;
  final String childName;
  final String facilityNumber;
  final String childAge;
  final String childGender;
  final String childHeight;
  final String childWeight;
  final DateTime? birthdate;
  final String birthplace;
  final List<String>? childConditions;
  final VaccineData vaccines;

  ChildrenData({
    this.childID = '',
    this.childName = '',
    this.facilityNumber = '',
    this.childAge = '',
    this.birthdate,
    this.birthplace = '',
    this.childGender = '',
    this.childHeight = '',
    this.childWeight = '',
    this.childConditions,
    VaccineData? vaccines,
  }) : vaccines = vaccines ?? VaccineData();
}

class VaccineData {
  String bcgVaccine;
  String hepaVaccine;
  String opv1Vaccine;
  String opv2Vaccine;
  String opv3Vaccine;
  String ipv1Vaccine;
  String ipv2Vaccine;
  String penta1Vaccine;
  String penta2Vaccine;
  String penta3Vaccine;
  String pcv1Vaccine;
  String pcv2Vaccine;
  String pcv3Vaccine;
  String mmrVaccine;

  DateTime? bcgDate;
  DateTime? hepaDate;
  DateTime? opv1Date;
  DateTime? opv2Date;
  DateTime? opv3Date;
  DateTime? ipv1Date;
  DateTime? ipv2Date;
  DateTime? penta1Date;
  DateTime? penta2Date;
  DateTime? penta3Date;
  DateTime? pcv1Date;
  DateTime? pcv2Date;
  DateTime? pcv3Date;
  DateTime? mmrDate;

  VaccineData(
      {this.bcgVaccine = '',
      this.hepaVaccine = '',
      this.opv1Vaccine = '',
      this.opv2Vaccine = '',
      this.opv3Vaccine = '',
      this.ipv1Vaccine = '',
      this.ipv2Vaccine = '',
      this.penta1Vaccine = '',
      this.penta2Vaccine = '',
      this.penta3Vaccine = '',
      this.pcv1Vaccine = '',
      this.pcv2Vaccine = '',
      this.pcv3Vaccine = '',
      this.mmrVaccine = '',
      this.bcgDate,
      this.hepaDate,
      this.opv1Date,
      this.opv2Date,
      this.opv3Date,
      this.ipv1Date,
      this.ipv2Date,
      this.penta1Date,
      this.penta2Date,
      this.penta3Date,
      this.pcv1Date,
      this.pcv2Date,
      this.pcv3Date,
      this.mmrDate});
}
