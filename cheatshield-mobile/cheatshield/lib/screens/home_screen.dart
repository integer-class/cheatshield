import 'package:flutter/material.dart';
import '../components/header/navbar.dart';
import '../components/footer/bottom_navbar.dart';
import '../components/body/home/home_component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Navbar(), // Header
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: HomeComponent(), // Body
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        // Footer
        activeIndex: _activeIndex,
        onDestinationSelected: (value) {
          setState(() {
            _activeIndex = value;
          });
        },
      ),
    );
  }
}