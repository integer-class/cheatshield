import 'package:cheatshield/components/body/profile/logout_button.dart';
import 'package:cheatshield/components/body/profile/profile_details.dart';
import 'package:cheatshield/components/body/profile/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/footer/bottom_navbar.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: <Widget>[
          const ProfileHeader(),
          const Divider(),
          const ProfileDetails(),
          LogoutButton(authNotifier: authNotifier),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        activeIndex: 2,
        onDestinationSelected: (int index) {
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/history');
          } else if (index == 2) {
            context.go('/profile');
          }
        },
      ),
    );
  }
}
