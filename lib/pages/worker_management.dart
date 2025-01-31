import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkerManagement extends ConsumerStatefulWidget {
  const WorkerManagement({super.key});

  @override
  ConsumerState<WorkerManagement> createState() => _WorkerManagementState();
}

class _WorkerManagementState extends ConsumerState<WorkerManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Text("Worker Management Page"),
        ),
      ),
    );
  }
}
