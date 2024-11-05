import 'package:flutter/material.dart';
import 'login_image.dart';
import 'login_form.dart';

class LoginComponent extends StatelessWidget {
  const LoginComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginImage(),
        SizedBox(height: 20),
        LoginForm(),
      ],
    );
  }
}
