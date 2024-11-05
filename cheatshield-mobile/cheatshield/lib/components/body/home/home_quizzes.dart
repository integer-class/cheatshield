import 'package:flutter/material.dart';

class HomeQuizzes extends StatelessWidget {
  const HomeQuizzes({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom di setiap baris
        childAspectRatio: 1,
      ),
      itemCount: 6, // Ubah sesuai kebutuhan
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Quiz ${index + 1}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
