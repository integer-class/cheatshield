import 'package:dio/dio.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  final String baseUrl = 'http://192.168.151.146:80/api/v1';

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/user',
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
      String token, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '$baseUrl/user',
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
