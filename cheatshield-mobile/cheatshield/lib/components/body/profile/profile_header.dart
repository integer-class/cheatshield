import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
        ),
      ),
      title: Text(
        'Al Azhar',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
