import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/providers/web/profile_provider.dart';
import 'package:cheatshield/providers/web/auth_provider.dart'; // Using authProvider

class ProfileDetails extends ConsumerWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authProvider); // Retrieve token from authProvider

    // If token is not available, display login message
    if (token == null) {
      return const Center(child: Text('Please login to view profile.'));
    }

    final profileAsync =
        ref.watch(profileProvider(token)); // Get profile using token

    return profileAsync.when(
      data: (profile) {
        return Column(
          children: <Widget>[
            ListTile(
              title: const Text('Name'),
              subtitle: Text(profile['name'] ?? 'No Name'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(profile['email'] ?? 'No Email'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            ListTile(
              title: const Text('NIM'),
              subtitle: Text(profile['nim'] ?? 'No NIM'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            const ListTile(
              title: Text('Update Password'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stackTrace) => Center(child: Text('Error: $e')),
    );
  }
}
