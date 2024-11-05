import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({super.key}); // Pastikan konstruktor ini sudah const

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Cheatshield',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
