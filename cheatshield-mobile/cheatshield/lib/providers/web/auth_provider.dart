import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/services/web/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<String?> {
  AuthNotifier() : super(null);

  final AuthService _authService = AuthService();

  // login
  Future<void> login(String email, String password) async {
    final token = await _authService.login(email, password);

    if (token != null) {
      state = token;
    } else {
      state = null;
    }
  }

  // logout
  Future<void> logout() async {
    final message = await _authService.logout(state!);

    if (message != null) {
      state = null;
    }
  }
}
