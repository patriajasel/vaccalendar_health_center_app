import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/pages/app_navigation.dart';
import 'package:vaccalendar_health_center_app/pages/login_page.dart';
import 'package:vaccalendar_health_center_app/services/firebase_firestore_services.dart';

class AuthenticationCheck extends ConsumerWidget {
  const AuthenticationCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return FutureBuilder<void>(
            future: FirebaseFirestoreServices().obtainAllNeededData(ref),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan.shade300,
                          Colors.white,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Center(child: CircularProgressIndicator()));
              } else if (futureSnapshot.hasError) {
                // ignore: avoid_print
                print("Error loading data: ${futureSnapshot.error}");
                return const Center(child: Text('Error loading user data'));
              } else {
                return const AppNavigation();
              }
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
