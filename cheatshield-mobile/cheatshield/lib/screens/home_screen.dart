import 'package:flutter/material.dart';
import 'package:cheatshield/components/header/navbar.dart';
import 'package:cheatshield/components/body/home/home_component.dart';
import 'package:cheatshield/components/footer/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Navbar(),
          const Expanded(
            child: SingleChildScrollView(
              child: HomeComponent(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
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
