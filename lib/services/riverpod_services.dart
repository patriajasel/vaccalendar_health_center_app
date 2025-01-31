import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/models/child_model.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';

final screenWidthProvider = StateProvider<double>((ref) => 0);

final screenHeightProvider = StateProvider<double>((ref) => 0);

final isLoadingProvider = StateProvider<bool>((ref) => false);

final childDataProvider = ChangeNotifierProvider<Children>(
  (ref) {
    return Children([]);
  },
);

final scheduleDataProvider = ChangeNotifierProvider<Schedules>(
  (ref) {
    return Schedules([]);
  },
);
