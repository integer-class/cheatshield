import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/services/web/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final profileProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, _) async {
  final profileService = ref.watch(profileServiceProvider);
  final profile = await profileService.getProfile();

  if (profile.containsKey('error')) {
    throw Exception(profile['error']);
  }

  return profile;
});

final profileUpdateProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
        (ref, data) async {
  final profileService = ref.watch(profileServiceProvider);
  final profile = await profileService.updateProfile(data);

  if (profile.containsKey('error')) {
    throw Exception(profile['error']);
  }

  return profile;
});
