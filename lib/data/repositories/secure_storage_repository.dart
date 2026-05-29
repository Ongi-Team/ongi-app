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

  Future<void> saveElderId(int elderId) async {
    await _storage.write(key: 'elderId', value: elderId.toString());
  }

  Future<int?> getElderId() async {
    final value = await _storage.read(key: 'elderId');
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> saveElderName(String name) async {
    await _storage.write(key: 'elder_name', value: name);
  }

  Future<String?> readElderName() async {
    return await _storage.read(key: 'elder_name');
  }

  Future<String?> readFcmToken() async {
    return await _storage.read(key: 'fcm_token');
  }

  Future<void> saveFcmToken(String token) async {
    await _storage.write(key: 'fcm_token', value: token);
  }

  ///FCM 토큰을 제외한 로그인 세션 데이터 삭제
  Future<void> deleteAuthData() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'role');
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'elderId');
    await _storage.delete(key: 'elder_name');
  }

  ///모든 데이터 삭제
  Future<void> deleteAllData() async {
    await _storage.deleteAll();
  }
}
