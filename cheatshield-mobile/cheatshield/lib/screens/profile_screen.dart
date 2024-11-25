import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/footer/bottom_navbar.dart'; // Pastikan path sesuai

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _activeIndex = 2; // Set index sesuai posisi yang aktif (Profile)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'assets/images/profile-placeholder.png', // Ganti dengan URL gambar profil Anda
              ),
            ),
            title: const Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Username'),
            subtitle: const Text('zharsuke'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Name'),
            subtitle: const Text('Al Azhar'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Update Password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          const Divider(),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Warna merah
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
              )),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        activeIndex: _activeIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _activeIndex = index;
          });

          // Menambahkan logika navigasi sesuai dengan index yang dipilih
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context
                .go('/history'); // Misalnya, ganti dengan rute history jika ada
          } else if (index == 2) {
            context.go('/profile');
          }
        },
      ),
    );
  }
}
