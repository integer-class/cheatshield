import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeQuizzes extends StatelessWidget {
  const HomeQuizzes({super.key});

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
            // Arahkan ke halaman kamera sebelum ke halaman quiz
            final result = await context.push('/camera');
            if (result == true) {
              context.go('/quiz');
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
