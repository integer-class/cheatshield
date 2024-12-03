import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/services/web/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(Dio());
});

final profileProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, token) async {
  final profileService = ref.watch(profileServiceProvider);
  final profile = await profileService.getProfile(token);

  if (profile.containsKey('error')) {
    throw Exception(profile['error']);
  }

  return profile; // Return profile data
});
