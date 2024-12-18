import 'package:cheatshield/components/body/profile/logout_button.dart';
import 'package:cheatshield/components/body/profile/profile_details.dart';
import 'package:cheatshield/components/body/profile/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDEF), // bg color
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FDEF), // primary color
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF010800), // primary-content
              fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFCBCFC3),
            height: 0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: <Widget>[
          const ProfileHeader(),
          const Divider(color: Color(0xFFCBCFC3)), // secondary color
          const ProfileDetails(),
          LogoutButton(authNotifier: authNotifier),
        ],
      ),
    );
  }
}
