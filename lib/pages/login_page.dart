import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaccalendar_health_center_app/services/firebase_auth_services.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isPassObscure = true;

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(screenWidthProvider);
    final screenHeight = ref.watch(screenHeightProvider);

    bool isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.cyan.shade500,
              ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/logo/VacCalendar_Logo.png',
                    scale: 1.5,
                  ),
                  Text(
                    'VacCalendar',
                    style: TextStyle(
                      fontFamily: 'SourGummy',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                          color: Colors.black.withValues(
                            alpha: 0.5,
                            blue: 0,
                            green: 0,
                            red: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '(Health Center App)',
                    style: TextStyle(
                      fontFamily: 'Hahmlet',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                          color: Colors.black.withValues(
                            alpha: 0.5,
                            blue: 0,
                            green: 0,
                            red: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Platform.isWindows
                            ? screenWidth * 0.4
                            : screenWidth * 0.15,
                        vertical: screenHeight * 0.01),
                    child: TextField(
                      controller: email,
                      style: TextStyle(
                        fontFamily: 'Hahmlet',
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          label: Text("Username"),
                          labelStyle: TextStyle(
                              fontFamily: 'Hahmlet',
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.cyan.shade700, width: 2))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Platform.isWindows
                            ? screenWidth * 0.4
                            : screenWidth * 0.15,
                        vertical: screenHeight * 0.01),
                    child: TextField(
                      style: TextStyle(
                        fontFamily: 'Hahmlet',
                      ),
                      controller: password,
                      obscureText: isPassObscure,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPassObscure = !isPassObscure;
                                });
                              },
                              icon: isPassObscure
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off)),
                          label: Text("Password"),
                          labelStyle: TextStyle(
                              fontFamily: 'Hahmlet',
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.cyan.shade700, width: 2))),
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fixedSize: Size(
                                  Platform.isWindows
                                      ? screenWidth * 0.2
                                      : screenWidth * 0.7,
                                  screenHeight * 0.04),
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            // Login admin

                            if (Platform.isWindows) {
                              await FirebaseAuthServices().loginAdminWindows(
                                  email.text, password.text, context, ref);
                            } else if (Platform.isAndroid) {
                              await FirebaseAuthServices().loginAdminAndroid(
                                  email.text, password.text, context, ref);
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontFamily: 'Hahmlet',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ))),
                ],
              ),
      ),
    );
  }
}
