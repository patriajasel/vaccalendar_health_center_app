import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:vaccalendar_health_center_app/assets/files/firebase_options.dart';
import 'package:vaccalendar_health_center_app/auth_check.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: OptionsFirebase().firebaseOptions);

  late Display display;

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    display = await screenRetriever.getPrimaryDisplay();

    WindowManager.instance
        .setMaximumSize(Size(display.size.width, display.size.height));
    WindowManager.instance
        .setMinimumSize(Size(display.size.width, display.size.height));
    WindowManager.instance.maximize();
    WindowManager.instance.setTitle("VacCalendar (Clinic)");
    WindowManager.instance.setPosition(Offset.infinite, animate: true);
    WindowManager.instance.setResizable(false);
    WindowManager.instance.center();
  }

  runApp(ProviderScope(
      child: Main(
    screenWidth: Platform.isWindows ? display.size.width : 0,
    screenHeight: Platform.isWindows ? display.size.height : 0,
  )));
}

class Main extends ConsumerWidget {
  final double screenWidth;
  final double screenHeight;
  const Main(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Store Screen Width and Screen Height for other page
    Future.microtask(() {
      if (Platform.isWindows) {
        ref.read(screenWidthProvider.notifier).state = screenWidth;
        ref.read(screenHeightProvider.notifier).state = screenHeight;
      } else if (Platform.isAndroid) {
        if (context.mounted) {
          ref.read(screenWidthProvider.notifier).state =
              MediaQuery.of(context).size.width;
          ref.read(screenHeightProvider.notifier).state =
              MediaQuery.of(context).size.height;
        }
      }
    });

    return MaterialApp(
        debugShowCheckedModeBanner: false, home: AuthenticationCheck());
  }
}
