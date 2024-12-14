import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/components/footer/bottom_navbar.dart';
import 'package:cheatshield/models/quiz_history_model.dart';
import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';

class HistoryComponent extends ConsumerStatefulWidget {
  const HistoryComponent({super.key});

  @override
  ConsumerState<HistoryComponent> createState() => _HistoryComponentState();
}

class _HistoryComponentState extends ConsumerState<HistoryComponent> {
  List<QuizHistory> _histories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      setState(() => _isLoading = true);
      final token = ref.read(authProvider);

      if (token == null) {
        setState(() {
          _error = 'Not authenticated';
          _isLoading = false;
        });
        return;
      }

      final quizNotifier = ref.read(quizProvider.notifier);
      final historiesResponse = await quizNotifier.getQuizHistory(token);

      if (historiesResponse != null) {
        setState(() {
          _histories = historiesResponse;
          _isLoading = false;
          _error = null;
        });
      } else {
        setState(() {
          _histories = [];
          _isLoading = false;
          _error = 'No history found';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FDEF),
        title: Text(
          'History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF010800), fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFCBCFC3),
            height: 0.5,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchHistory,
        child: _buildBody(),
      ),
      bottomNavigationBar: BottomNavbar(
        activeIndex: 1,
        onDestinationSelected: (int index) {},
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_histories.isEmpty) {
      return const Center(
        child: Text(
          'No completed quizzes yet.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF343300),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _histories.length,
      itemBuilder: (context, index) {
        final history = _histories[index];

        return Column(
          children: history.quizSessionResults.map((quiz) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              color: const Color(0xFF343300),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(
                  Icons.check_circle_outline,
                  size: 40,
                  color: Color(0xFFD2D3C7),
                ),
                title: Text(
                  quiz.quizTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD2D3C7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Score: ${quiz.totalScore}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFD2D3C7),
                      ),
                    ),
                    Text(
                      'Correct: ${quiz.correctAnswers}/${quiz.correctAnswers + quiz.incorrectAnswers}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD2D3C7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
