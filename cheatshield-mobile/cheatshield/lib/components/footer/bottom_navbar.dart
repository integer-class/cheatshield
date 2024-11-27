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
    return NavigationBar(
      selectedIndex: activeIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (value) {
        onDestinationSelected(value);
        if (value == 0) {
          context.go('/home'); // Home
        } else if (value == 1) {
          // History (tambahkan navigasi jika ada)
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
    );
  }
}
