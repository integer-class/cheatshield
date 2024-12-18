import 'package:cheatshield/config.dart';
import 'package:cheatshield/services/http.dart';
import 'package:cheatshield/services/storage.dart';
import 'package:dio/dio.dart';

class ProfileService {
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await httpClient.get(
        '$apiBaseUrl/user',
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

      if (response.statusCode == 200) {
        return response.data ?? {}; // Ensure non-null response
      } else if (response.statusCode == 401) {
        return {'error': 'Unauthorized: Invalid or expired token'};
      } else {
        return {
          'error': 'Failed to load profile, status code: ${response.statusCode}'
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'error':
              'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'
        };
      } else {
        return {'error': 'Network error: ${e.message}'};
      }
    }
  }

  // updateProfile method
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await httpClient.put(
        '$apiBaseUrl/user',
        data: data,
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

      if (response.statusCode == 200) {
        return response.data ?? {}; // Ensure non-null response
      } else if (response.statusCode == 401) {
        return {'error': 'Unauthorized: Invalid or expired token'};
      } else {
        return {
          'error':
              'Failed to update profile, status code: ${response.statusCode}'
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'error':
              'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}'
        };
      } else {
        return {'error': 'Network error: ${e.message}'};
      }
    }
  }
}
