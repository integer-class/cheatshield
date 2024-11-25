import 'package:cheatshield/screens/camera_screen.dart';
import 'package:cheatshield/screens/home_screen.dart';
import 'package:cheatshield/screens/login_screen.dart';
import 'package:cheatshield/screens/profile_screen.dart';
import 'package:cheatshield/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_router/go_router.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
    GoRoute(path: '/camera', builder: (context, state) => const CameraScreen()),
    GoRoute(
        path: '/profile', builder: (context, state) => const ProfileScreen()),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cheatshield',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      routerConfig: _router,
    );
  }
}
