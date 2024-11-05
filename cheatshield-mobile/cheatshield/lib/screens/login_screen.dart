import 'package:flutter/material.dart';
import '../components/body/login/login_component.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoginComponent(),
      ),
    );
  }
}
