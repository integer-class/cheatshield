import 'package:cheatshield/components/footer/bottom_navbar.dart';
import 'package:flutter/material.dart';

class HistoryComponent extends StatefulWidget {
  const HistoryComponent({super.key});

  @override
  State<HistoryComponent> createState() => _HistoryComponentState();
}

class _HistoryComponentState extends State<HistoryComponent> {
  final List<Map<String, dynamic>> _completedQuizzes = [
    {
      'title': 'Quiz 1',
      'score': 85,
    },
    {
      'title': 'Quiz 2',
      'score': 90,
    },
    {
      'title': 'Quiz 3',
      'score': 75,
    },
    {
      'title': 'Quiz 4',
      'score': 100,
    },
    {
      'title': 'Quiz 5',
      'score': 80,
    },
    {
      'title': 'Quiz 6',
      'score': 95,
    },
    {
      'title': 'Quiz 7',
      'score': 85,
    },
    {
      'title': 'Quiz 8',
      'score': 90,
    },
    {
      'title': 'Quiz 9',
      'score': 75,
    },
    {
      'title': 'Quiz 10',
      'score': 100,
    },
  ];

  Future<void> _confirmDelete(BuildContext context, int index) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this history?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        _completedQuizzes.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('History deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _completedQuizzes.isEmpty
          ? const Center(
              child: Text(
                'No completed quizzes yet.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: _completedQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = _completedQuizzes[index];
                return GestureDetector(
                  onLongPress: () => _confirmDelete(context, index),
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
                            Icons.check_circle_outline,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            quiz['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Score: ${quiz['score']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavbar(
        activeIndex: 1,
        onDestinationSelected: (int index) {},
      ),
    );
  }
}
