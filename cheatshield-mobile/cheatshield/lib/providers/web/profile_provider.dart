import 'package:cheatshield/services/web/profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@riverpod
class Profile extends _$Profile {
  late ProfileService profileService;

  @override
  Map<String, dynamic> build() {
    profileService = ref.read(profileServiceProvider.notifier);
    return {};
  }

  Future<Map<String, dynamic>> getProfile() async {
    final profile = await profileService.getProfile();

    if (profile.containsKey('error')) {
      throw Exception(profile['error']);
    }

    return profile;
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final profile = await profileService.updateProfile(data);

    if (profile.containsKey('error')) {
      throw Exception(profile['error']);
    }

    return profile;
  }
}
