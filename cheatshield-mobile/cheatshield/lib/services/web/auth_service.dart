import 'package:cheatshield/config.dart';
import 'package:cheatshield/services/http.dart';
import 'package:cheatshield/services/storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  Future<String?> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        '$apiBaseUrl/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      await storage.write(key: 'token', value: response.data['token']);

      if (response.statusCode == 200) {
        return response.data['token'];
      }

      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 302) {
          return 'Redirection: further action needs to be taken in order to complete the request';
        } else {
          return 'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        }
      } else {
        // Handle other errors such as network issues
        return 'Network error: ${e.message}';
      }
    }
  }

  Future<String?> logout() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await httpClient.post(
        '$apiBaseUrl/auth/logout',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        return response.data['message'];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 302) {
          return 'Redirection: further action needs to be taken in order to complete the request';
        } else {
          return 'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        }
      } else {
        return 'Network error: ${e.message}';
      }
    }
  }
}
