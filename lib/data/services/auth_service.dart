import 'package:dio/dio.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';

class AuthService {
  final Dio _dio;
  final SecureStorageRepository _secureStorage;

  AuthService(this._dio, this._secureStorage);

  Future<void> reissueToken() async {
    final refreshToken = await _secureStorage.readRefreshToken();
    if (refreshToken == null) throw Exception('리프레시 토큰이 없습니다.');

    final response = await _dio.post(
      'reissue', // TODO: 실제 엔드포인트로 변경
      data: {'refreshToken': refreshToken},
      options: Options(extra: {'skipAuthToken': true}),
    );

    final newAccessToken = response.data['accessToken'] as String?;
    final newRefreshToken = response.data['refreshToken'] as String?;

    if (newAccessToken == null) throw Exception('새 액세스 토큰이 없습니다.');
    await _secureStorage.saveAccessToken(newAccessToken);
    if (newRefreshToken != null) {
      await _secureStorage.saveRefreshToken(newRefreshToken);
    }
  }
}
