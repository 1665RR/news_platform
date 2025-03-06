import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _secureStorage = const FlutterSecureStorage();

  static const _jwtKey = 'jwt';
  static const _refreshTokenKey = 'refreshToken';

  Future<void> saveToken({
    required String jwt,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: _jwtKey, value: jwt);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getJwt() async {
    return await _secureStorage.read(key: _jwtKey);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _secureStorage.delete(key: _jwtKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  Future<void> clearStorage() async {
    await _secureStorage.deleteAll();
  }
}