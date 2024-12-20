import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage.g.dart';

class Storage {
  static final _storage = FlutterSecureStorage();

  Future<String?> get(String key) async {
    return _storage.read(key: key);
  }

  Future<void> set(String key, String? value) async {
    return _storage.write(key: key, value: value);
  }

  Future<void> remove(String key) async {
    return _storage.delete(key: key);
  }
}

@Riverpod(keepAlive: true)
Storage storage(Ref ref) => Storage();
