import 'package:cheatshield/services/storage.dart';
import 'package:cheatshield/services/web/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late AuthService authService;
  late Storage storage;

  @override
  Map<String, dynamic> build() {
    authService = ref.watch(authServiceProvider.notifier);
    storage = ref.watch(storageProvider);
    return {
      'is_loading': false,
      'token': null,
    };
  }

  Future<bool> login(String email, String password) async {
    state['is_loading'] = true;
    final token = await authService.login(email, password);
    state['is_loading'] = false;

    if (token != null) {
      await storage.set('token', token);
      state['token'] = token;
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    state['is_loading'] = true;
    await authService.logout();
    await storage.remove('token');
    state['is_loading'] = false;
  }
}
