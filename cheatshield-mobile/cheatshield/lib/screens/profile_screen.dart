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
          const ListTile(
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
          ),
          const Divider(),
          const ListTile(
            title: Text('Username'),
            subtitle: Text('zharsuke'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          const ListTile(
            title: Text('Name'),
            subtitle: Text('Al Azhar'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          const ListTile(
            title: Text('NIM'),
            subtitle: Text('2241783756'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          const ListTile(
            title: Text('Update Password'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () async {
                // Logout using authNotifier
                await authNotifier.logout();

                // Redirect to login page
                if (context.mounted) {
                  context.go('/');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
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
