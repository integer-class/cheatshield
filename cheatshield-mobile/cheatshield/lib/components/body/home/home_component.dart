import 'package:flutter/material.dart';
import 'home_code.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDEF), // bg color
      body: Center(
        child: HomeCode(),
      ),
    );
  }
}
