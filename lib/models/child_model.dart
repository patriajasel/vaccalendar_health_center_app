import 'package:flutter/foundation.dart';

class Children extends ChangeNotifier {
  List<ChildModel> children;

  Children(this.children);

  void addChild(ChildModel child) {
    children.add(child);
    notifyListeners();
  }

  void reset() {
    children.clear();
    notifyListeners();
  }
}

class ChildModel {
  final String parent;
  final String childName;
  final String childID;
  final List<String> childConditions;

  ChildModel(
      {required this.parent,
      required this.childName,
      required this.childID,
      required this.childConditions});
}
