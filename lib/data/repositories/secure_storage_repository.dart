import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ///토큰
  Future<String?> readAccessToken() async {
    return await _storage.read(key: "access_token");
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(key: "access_token", value: accessToken);
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: "refresh_token", value: refreshToken);
  }

  ///유저 정보
  Future<String?> readUserName() async {
    return await _storage.read(key: "user_name");
  }

  Future<void> saveUserName(String name) async {
    await _storage.write(key: "user_name", value: name);
  }

  Future<String?> readRole() async {
    return await _storage.read(key: "role");
  }

  Future<void> saveRole(String? role) async {
    await _storage.write(key: "role", value: role);
  }

  Future<void> saveUserId(int userId) async {
    await _storage.write(key: 'userId', value: userId.toString());
  }

  Future<int?> getUserId() async {
    final value = await _storage.read(key: 'userId');
    return value != null ? int.tryParse(value) : null;
  }

  Future<String?> readFcmToken() async {
    return await _storage.read(key: 'fcm_token');
  }

  Future<void> saveFcmToken(String token) async {
    await _storage.write(key: 'fcm_token', value: token);
  }

  ///모든 데이터 삭제
  Future<void> deleteAllData() async {
    await _storage.deleteAll();
  }
}
