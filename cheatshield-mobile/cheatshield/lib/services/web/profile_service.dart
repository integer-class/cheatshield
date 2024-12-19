import 'package:cheatshield/services/http.dart';
import 'package:cheatshield/services/storage.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_service.g.dart';

@riverpod
class ProfileService extends _$ProfileService {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await ref.read(storageProvider).get('token');
      final response = await httpClient.get(
        '/user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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
      final token = await ref.read(storageProvider).get('token');
      final response = await httpClient.put(
        '/user',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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
