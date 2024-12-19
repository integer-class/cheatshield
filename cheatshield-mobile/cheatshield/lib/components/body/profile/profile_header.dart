import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileHeader extends ConsumerWidget {
  final Map<String, dynamic> profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF010800), // primary-content
        ),
      ),
    );
  }
}
