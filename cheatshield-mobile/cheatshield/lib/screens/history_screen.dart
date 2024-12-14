import 'package:cheatshield/components/body/history/history_component.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDEF), // bg color
      body: const HistoryComponent(),
    );
  }
}
