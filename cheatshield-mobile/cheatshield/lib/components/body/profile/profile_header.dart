import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/providers/web/profile_provider.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

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
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              profile['profile_picture'] ??
                  'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
            ),
          ),
          title: Text(
            profile['name'] ?? 'No Name',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stackTrace) => Center(child: Text('Error: $e')),
    );
  }
}
