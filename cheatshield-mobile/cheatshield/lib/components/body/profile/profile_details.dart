import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/providers/web/profile_provider.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';
import 'package:go_router/go_router.dart';

class ProfileDetails extends ConsumerWidget {
  final Map<String, dynamic> profile;

  const ProfileDetails({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text(
            'Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            profile['name'] ?? 'No Name',
            style: const TextStyle(color: Color(0xFF010800)), // primary-content
          ),
        ),
        const Divider(color: Color(0xFFCBCFC3)), // secondary color
        ListTile(
          title: const Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            profile['email'] ?? 'No Email',
            style: const TextStyle(color: Color(0xFF010800)), // primary-content
          ),
        ),
        const Divider(color: Color(0xFFCBCFC3)), // secondary color
        ListTile(
          title: const Text(
            'NIM',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            profile['nim'] ?? 'No NIM',
            style: const TextStyle(color: Color(0xFF010800)), // primary-content
          ),
        ),
        const Divider(color: Color(0xFFCBCFC3)), // secondary color
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: ElevatedButton(
            onPressed: () => context.go('/update-profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              'Update Profile',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
