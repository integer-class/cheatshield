import 'package:flutter/material.dart';
import 'home_code.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: HomeCode(),
      ),
    );
  }
}
