import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                color: Color(0xFF010800),
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return IconThemeData(
                    color: Colors.white,
                  );
                }

                return IconThemeData(
                  color: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ),
          child: NavigationBar(
            selectedIndex: _activeIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (value) {
              setState(() {
                _activeIndex = value;
              });
              switch (value) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/history');
                  break;
                case 2:
                  context.go('/profile');
                  break;
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
