import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  // baseUrl
  final String baseUrl =
      'http://192.168.254.146:80/api/v1'; // Change this to your own IP address

  // Login
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
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
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );

      // if response status code is 200, return the token
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        // if response status code is not 200, return the error message
        return response.data['message'];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle the error based on the status code
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

  // logout
  Future<String?> logout(String token) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/logout',
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

      // if response status code is 200, return the message
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        // if response status code is not 200, return the error message
        return response.data['message'];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle the error based on the status code
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
}
