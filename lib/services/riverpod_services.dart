import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/models/child_model.dart';
import 'package:vaccalendar_health_center_app/models/rhu_schedule_model.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';
import 'package:vaccalendar_health_center_app/models/vaccine_model.dart';
import 'package:vaccalendar_health_center_app/models/workers_model.dart';

final screenWidthProvider = StateProvider<double>((ref) => 0);

final screenHeightProvider = StateProvider<double>((ref) => 0);

final isLoadingProvider = StateProvider<bool>((ref) => false);

final childDataProvider = ChangeNotifierProvider<Children>(
  (ref) {
    return Children([]);
  },
);

final userDataProvider = ChangeNotifierProvider<Users>(
  (ref) {
    return Users([]);
  },
);

final scheduleDataProvider = ChangeNotifierProvider<Schedules>(
  (ref) {
    return Schedules([]);
  },
);

final workerDataProvider = ChangeNotifierProvider<Workers>(
  (ref) {
    return Workers([]);
  },
);

final vaccineDataProvider = ChangeNotifierProvider<VaccineDetails>(
  (ref) {
    return VaccineDetails([]);
  },
);

final rhuScheduleProvider = ChangeNotifierProvider<RhuSchedules>(
  (ref) {
    return RhuSchedules([]);
  },
);

final searchQuerySchedProvider = StateProvider<String>((ref) => '');
final searchControllerSchedProvider = Provider((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final searchQueryChildProvider = StateProvider<String>((ref) => '');
final searchControllerChildProvider = Provider((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final searchQueryParentProvider = StateProvider<String>((ref) => '');
final searchControllerParentProvider = Provider((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final searchQueryWorkerProvider = StateProvider<String>((ref) => '');
final searchControllerWorkerProvider = Provider((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});
