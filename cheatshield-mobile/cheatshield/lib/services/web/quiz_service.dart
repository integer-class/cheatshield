import 'package:cheatshield/models/quiz_model.dart';
import 'package:dio/dio.dart';
import 'package:cheatshield/models/quiz_history_model.dart';

class QuizService {
  final Dio _dio = Dio();

  final String baseUrl = 'http://192.168.1.4/api/v1';

  Future<QuizResponse?> joinQuiz(String code, String token) async {
    try {
      final response = await _dio.post(
        '$baseUrl/quiz/join/$code',
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

  Future<Map<String, dynamic>?> submitAnswerForQuestion(String quizSessionId,
      String questionId, String answerId, String token) async {
    try {
      final response = await _dio.post(
        '$baseUrl/quiz/answer',
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

  Future<Map<String, dynamic>?> finishQuizSession(
      String quizSessionId, String token) async {
    try {
      final response = await _dio.post(
        '$baseUrl/quiz/finish',
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
  Future<List<QuizHistory>?> getQuizHistory(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/quiz/history',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Quiz History Raw Response Status Code: ${response.statusCode}');
      print('Quiz History Raw Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        // If the response is a map instead of a list, wrap it in a list
        if (response.data is Map) {
          return [QuizHistory.fromJson(response.data)];
        }

        return (response.data as List)
            .map((e) => QuizHistory.fromJson(e))
            .toList();
      } else {
        print('Quiz History Response Error: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Quiz History Exception: $e');
      return null;
    }
  }
}
