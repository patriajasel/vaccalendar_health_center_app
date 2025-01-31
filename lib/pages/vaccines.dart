import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Vaccines extends ConsumerStatefulWidget {
  const Vaccines({super.key});

  @override
  ConsumerState<Vaccines> createState() => _VaccinesState();
}

class _VaccinesState extends ConsumerState<Vaccines> {
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
          child: Text("Vaccines Page"),
        ),
      ),
    );
  }
}
