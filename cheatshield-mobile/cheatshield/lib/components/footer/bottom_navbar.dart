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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute =
          GoRouter.of(context).routeInformationProvider.value.uri;
      setState(() {
        _activeIndex = _routeNameToIndex(currentRoute.path);
      });
    });
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
              TextStyle(
                color: Theme.of(context).colorScheme.primary,
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
              context.go(_indexToRouteName(value));
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

  int _routeNameToIndex(String routeName) {
    if (routeName == '/home') {
      return 0;
    }

    if (routeName == '/history') {
      return 1;
    }

    if (routeName.contains('profile')) {
      return 2;
    }

    return 0;
  }

  String _indexToRouteName(int index) {
    switch (index) {
      case 0:
        return '/home';
      case 1:
        return '/history';
      case 2:
        return '/profile';
    }
    return '/home';
  }
}
