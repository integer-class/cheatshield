import 'package:cheatshield/config.dart';
import 'package:cheatshield/models/quiz_model.dart';
import 'package:cheatshield/services/storage.dart';
import 'package:dio/dio.dart';
import 'package:cheatshield/models/quiz_history_model.dart';
import 'package:flutter/material.dart';

class QuizService {
  final Dio _dio = Dio();

  Future<QuizResponse?> joinQuiz(String code) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await _dio.post(
        '$apiBaseUrl/quiz/join/$code',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return QuizResponse.fromJson(response.data);
      } else {
        return null;
      }
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
      final token = await storage.read(key: 'token');
      final response = await _dio.post(
        '$apiBaseUrl/quiz/answer',
        data: {
          'quiz_session_id': quizSessionId,
          'question_id': questionId,
          'answer_id': answerId,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
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
      final token = await storage.read(key: 'token');
      final response = await _dio.post(
        '$apiBaseUrl/quiz/finish',
        data: {'quiz_session_id': quizSessionId},
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
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

  // history
  Future<List<QuizHistory>?> getQuizHistory() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await _dio.get(
        '$apiBaseUrl/quiz/history',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint(
          'Quiz History Raw Response Status Code: ${response.statusCode}');
      debugPrint('Quiz History Raw Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        return (response.data.data as List)
            .map((e) => QuizHistory.fromJson(e))
            .toList();
      } else {
        debugPrint('Quiz History Response Error: ${response.data}');
        return null;
      }
    } catch (e) {
      debugPrint('Quiz History Exception: $e');
      return null;
    }
  }
}
