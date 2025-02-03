import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:vaccalendar_health_center_app/pages/dashboard.dart';
import 'package:vaccalendar_health_center_app/pages/schedules_page.dart';
import 'package:vaccalendar_health_center_app/pages/user_management.dart';
import 'package:vaccalendar_health_center_app/pages/worker_management.dart';
import 'package:vaccalendar_health_center_app/services/riverpod_services.dart';

class AppNavigation extends ConsumerStatefulWidget {
  const AppNavigation({super.key});

  @override
  ConsumerState<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends ConsumerState<AppNavigation> {
  final sidebarController =
      SidebarXController(selectedIndex: 0, extended: true);

  final sidebarKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = ref.watch(screenHeightProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      key: sidebarKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            SidebarX(
              controller: sidebarController,
              extendIcon: Icons.swipe_right_alt,
              collapseIcon: Icons.swipe_left_alt,
              theme: SidebarXTheme(
                  itemTextPadding: EdgeInsets.symmetric(horizontal: 10),
                  selectedItemTextPadding: EdgeInsets.symmetric(horizontal: 10),
                  selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  textStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'SourGummy',
                      fontSize: 18),
                  hoverTextStyle:
                      TextStyle(color: Colors.cyanAccent, fontSize: 18),
                  selectedIconTheme: IconThemeData(
                      color: Colors.yellowAccent.shade100, size: 30),
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  iconTheme: IconThemeData(color: Colors.white, size: 30)),
              extendedTheme: SidebarXTheme(width: 300),
              headerBuilder: (context, extended) {
                return SizedBox(
                  height: screenHeight * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'lib/assets/logo/VacCalendar_Logo.png',
                          scale: 4,
                        ),
                      ),
                      if (extended)
                        Center(
                          child: Text(
                            "Clinic App",
                            style: TextStyle(
                                fontFamily: 'SourGummy',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )
                    ],
                  ),
                );
              },
              headerDivider: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
              ),
              items: [
                SidebarXItem(icon: Icons.insert_chart, label: 'Dashboard'),
                SidebarXItem(icon: Icons.person, label: 'Patient\'s Data'),
                SidebarXItem(icon: Icons.masks, label: 'Worker Management'),
                SidebarXItem(icon: Icons.calendar_month, label: 'Schedules'),
              ],
              footerItems: [
                SidebarXItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () async {
                    ref.read(childDataProvider.notifier).reset();
                    ref.read(scheduleDataProvider.notifier).reset();
                    ref.read(userDataProvider.notifier).reset();
                    ref.read(vaccineDataProvider.notifier).reset();
                    ref.read(workerDataProvider.notifier).reset();
                    await FirebaseAuth.instance.signOut();
                  },
                )
              ],
            ),
            Expanded(
                child: Center(
              child: AnimatedBuilder(
                  animation: sidebarController,
                  builder: (context, child) {
                    switch (sidebarController.selectedIndex) {
                      case 0:
                        return Dashboard();
                      case 1:
                        return UserManagement();
                      case 2:
                        return WorkerManagement();
                      case 3:
                        return SchedulePage();
                      default:
                        return Center(
                          child: Text("Exceeded the navigation"),
                        );
                    }
                  }),
            ))
          ],
        ),
      ),
    );
  }
}
