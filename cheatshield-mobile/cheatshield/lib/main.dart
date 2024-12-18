import 'package:cheatshield/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cheatshield',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue).copyWith(
          surface: Color(0xFFf5f5f5),
          primary: Color(0xFF18171e),
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.comfortaa().fontFamily,
      ),
      routerConfig: appRouter,
    );
  }
}
