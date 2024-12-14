import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: const Color(0xFFF8FDEF),
          title: Text(
            'CheatShield',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF010800),
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0,
        ),
        const Divider(
          height: 0.5,
          color: Color(0xFFCBCFC3),
          thickness: 0.5,
        ),
      ],
    );
  }
}
