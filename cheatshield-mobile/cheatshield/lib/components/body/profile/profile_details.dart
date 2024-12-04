import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/providers/web/profile_provider.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';
import 'package:go_router/go_router.dart';

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
              title: const Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                profile['name'] ?? 'No Name',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                profile['email'] ?? 'No Email',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'NIM',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                profile['nim'] ?? 'No NIM',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: ElevatedButton(
                onPressed: () => context.go('/update-profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stackTrace) => Center(child: Text('Error: $e')),
    );
  }
}
