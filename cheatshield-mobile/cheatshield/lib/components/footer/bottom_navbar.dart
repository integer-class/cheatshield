import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onDestinationSelected;

  const BottomNavbar({
    super.key,
    required this.activeIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          height: 0.5,
          color: Color(0xFFCBCFC3),
          thickness: 0.5,
        ),
        NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: const Color(0xFFF8FDEF),
            indicatorColor: const Color(0xFFCBCFC3),
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                color: Color(0xFF010800),
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: Color(0xFF343300));
              }
              return const IconThemeData(color: Color(0xFF343300));
            }),
          ),
          child: NavigationBar(
            selectedIndex: activeIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (value) {
              onDestinationSelected(value);
              if (value == 0) {
                context.go('/home'); // Home
              } else if (value == 1) {
                context.go('/history'); // History
              } else if (value == 2) {
                context.go('/profile'); // Profile
              }
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
