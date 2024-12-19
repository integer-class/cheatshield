import 'package:cheatshield/components/body/profile/logout_button.dart';
import 'package:cheatshield/components/body/profile/profile_details.dart';
import 'package:cheatshield/components/body/profile/profile_header.dart';
import 'package:cheatshield/providers/web/profile_provider.dart';
import 'package:cheatshield/services/web/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider.notifier).getProfile();

    return FutureBuilder(
      future: profile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: <Widget>[
              ProfileHeader(profile: snapshot.data as Map<String, dynamic>),
              const Divider(color: Color(0xFFCBCFC3)), // secondary color
              ProfileDetails(profile: snapshot.data as Map<String, dynamic>),
              LogoutButton(),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
