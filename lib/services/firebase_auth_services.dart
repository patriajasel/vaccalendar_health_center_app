// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/pages/dashboard.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class FirebaseAuthServices {
  Future<void> loginAdminWindows(String email, String password,
      BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String userID = FirebaseAuth.instance.currentUser!.uid;

      bool checkAdmin =
          await FirebaseFirestoreServices().checkUserRoleWindows(userID);

      if (checkAdmin == true) {
        ref.read(isLoadingProvider.notifier).state = false;

        final userID = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestoreServices().addWorkerLogs(
            userID, 'Admin', DateTime.now(), 'Logged in on ${DateTime.now()}');
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
      } else {
        ref.read(isLoadingProvider.notifier).state = false;
        await FirebaseAuth.instance.signOut();

        final userID = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestoreServices().addWorkerLogs(
            userID, 'Admin', DateTime.now(), 'Logged in on ${DateTime.now()}');
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid credentials")));
        }
      }
    } on FirebaseAuthException catch (e) {
      ref.read(isLoadingProvider.notifier).state = false;
      print("Error code: ${e.code}");
      if (e.code == 'invalid-credential') {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid credentials")));
        }
      }
    } catch (e) {
      print("Login admin failed");
    }
  }

  Future<void> loginAdminAndroid(String email, String password,
      BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String userID = FirebaseAuth.instance.currentUser!.uid;

      bool checkAdmin =
          await FirebaseFirestoreServices().checkUserRoleAndroid(userID);

      if (checkAdmin == true) {
        ref.read(isLoadingProvider.notifier).state = false;
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
      } else {
        ref.read(isLoadingProvider.notifier).state = false;
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid credentials")));
        }
      }
    } on FirebaseAuthException catch (e) {
      ref.read(isLoadingProvider.notifier).state = false;
      print("Error code: ${e.code}");
      if (e.code == 'invalid-credential') {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid credentials")));
        }
      }
    } catch (e) {
      print("Login admin failed");
    }
  }
}
