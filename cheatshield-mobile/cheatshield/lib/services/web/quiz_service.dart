import 'package:cheatshield/models/quiz_model.dart';
import 'package:cheatshield/services/http.dart';
import 'package:cheatshield/services/storage.dart';
import 'package:dio/dio.dart';
import 'package:cheatshield/models/quiz_history_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_service.g.dart';

@Riverpod(keepAlive: true)
class QuizService extends _$QuizService {
  @override
  Future<QuizResponse?> build() async {
    return null;
  }

  Future<QuizResponse?> joinQuiz(String code) async {
    try {
      final token = await ref.read(storageProvider).get('token');
      final response = await httpClient.post(
        '/quiz/join/$code',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return QuizResponse.fromJson(response.data);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitAnswerForQuestion(
    String quizSessionId,
    String questionId,
    String answerId,
  ) async {
    try {
      final token = await ref.read(storageProvider).get('token');
      final response = await httpClient.post(
        '/quiz/answer',
        data: {
          'quiz_session_id': quizSessionId,
          'question_id': questionId,
          'answer_id': answerId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.statusCode == 200
          ? response.data
          : {'message': response.data?['message'] ?? 'Error submitting answer'};
    } catch (e) {
      return {'message': 'Failed to connect to server: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>?> finishQuizSession(String quizSessionId) async {
    try {
      final token = await ref.read(storageProvider).get('token');
      final response = await httpClient.post(
        '/quiz/finish',
        data: {
          'quiz_session_id': quizSessionId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.statusCode == 200
          ? response.data
          : {'message': response.data?['message'] ?? 'Error finishing quiz'};
    } catch (e) {
      return {'message': 'Failed to connect to server: ${e.toString()}'};
    }
  }

  Future<List<QuizSessionResult>?> getQuizHistory() async {
    try {
      final token = await ref.read(storageProvider).get('token');
      final response = await httpClient.get(
        '/quiz/history',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return (response.data["data"] as List<dynamic>)
            .map((e) => QuizSessionResult.fromJson(e))
            .toList();
      } else {
        debugPrint('Quiz History Response Error: ${response.data}');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      debugPrint('Quiz History Exception: $e');
      return null;
    }
  }
}
