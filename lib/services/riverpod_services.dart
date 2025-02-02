import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/models/child_model.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';

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
