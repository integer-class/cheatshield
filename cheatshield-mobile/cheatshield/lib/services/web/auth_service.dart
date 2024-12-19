import 'package:cheatshield/services/http.dart';
import 'package:cheatshield/services/storage.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  String? build() {
    return null;
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      await ref.read(storageProvider).set('token', response.data['token']);

      if (response.statusCode == 200) {
        return response.data['token'];
      }

      throw Exception(response.data["message"]);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      }

      rethrow;
    }
  }

  Future<String?> logout() async {
    try {
      final token = await ref.read(storageProvider).get('token');
      final response = await httpClient.post(
        '/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      }

      rethrow;
    }
  }
}
