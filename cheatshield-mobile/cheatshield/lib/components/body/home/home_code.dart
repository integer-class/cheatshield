import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';
import 'package:go_router/go_router.dart';

class HomeCode extends ConsumerStatefulWidget {
  const HomeCode({super.key});

  @override
  ConsumerState<HomeCode> createState() => _HomeCodeState();
}

class _HomeCodeState extends ConsumerState<HomeCode> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinQuiz(BuildContext context) async {
    final quizNotifier = ref.read(quizProvider.notifier);
    final token = ref.watch(authProvider); // Replace with actual token
    final code = _codeController.text.trim();

    // Input validation
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a quiz code')),
      );
      return;
    }

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token is missing')),
      );
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      await quizNotifier.joinQuiz(code, token);

      // Reset loading state
      setState(() {
        _isLoading = false;
      });

      // Check if quiz state has been updated successfully
      final quiz = ref.read(quizProvider);

      if (quiz != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Joined quiz successfully')),
        );
        context.go('/quiz');
      } else {
        // Handle case where quiz is null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join quiz')),
        );
      }
    } catch (e) {
      // Reset loading state in case of an unexpected error
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Quiz Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _joinQuiz(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF343300), // Primary color
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Join Quiz',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFD2D3C7), // Primary-content color
                      ),
                    ),
                  ),

            // ElevatedButton(
            //     onPressed: () => _joinQuiz(context),
            //     style: ElevatedButton.styleFrom(
            //       minimumSize: const Size(double.infinity, 50),
            //     ),
            //     child: const Text('Join Quiz'),
            //   ),
          ],
        ),
      ),
    );
  }
}
