import 'package:flutter/material.dart';
import 'package:cheatshield/components/body/home/home_code.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const HomeCode(),
    );
  }
}
