import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/services/web/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<String?> {
  AuthNotifier() : super(null);

  final AuthService _authService = AuthService();

  // login
  Future<bool> login(String email, String password) async {
    final token = await _authService.login(email, password);

    if (token != null &&
        !token.contains('email') &&
        !token.contains('password')) {
      state = token;
      print(token);
      return true;
    } else {
      state = null;
      return false;
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
