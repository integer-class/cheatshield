import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeQuizzes extends StatelessWidget {
  const HomeQuizzes({super.key});

  // Fungsi untuk menampilkan dialog izin
  Future<bool> _showPermissionDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // Pengguna tidak bisa menutup dialog dengan mengetuk di luar
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
              'Before joining the quiz, you must allow camera access permission.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Pilihan Deny
              },
              child: const Text('Deny'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Pilihan Allow
              },
              child: const Text('Allow'),
            ),
          ],
        );
      },
    ).then((value) =>
        value ??
        false); // Mengembalikan nilai default false jika dialog ditutup
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom di setiap baris
        childAspectRatio: 0.9, // Menurunkan aspect ratio agar lebih tinggi
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: 6, // Ubah sesuai kebutuhan
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            // Menampilkan dialog izin sebelum mengarahkan ke halaman kamera
            bool isAllowed = await _showPermissionDialog(context);

            if (isAllowed) {
              // Jika diizinkan, arahkan ke halaman kamera
              final result = await context.push('/camera');
              if (result == true) {
                context.go('/quiz');
              }
            } else {
              // Jika tidak diizinkan, beri tahu pengguna
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Camera permission denied!')),
              );
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quiz ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
