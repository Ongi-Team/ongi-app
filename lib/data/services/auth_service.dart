import 'package:dio/dio.dart';
import 'package:ongi_app/core/constants/apis.dart';
import 'package:ongi_app/data/dto/request/login_request_dto.dart';
import 'package:ongi_app/data/dto/request/signup_request_dto.dart';
import 'package:ongi_app/data/dto/response/login_response_dto.dart';
import 'package:ongi_app/data/network/api_exception.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';

class AuthService {
  final Dio _dio;
  final SecureStorageRepository _secureStorage;

  AuthService(this._dio, this._secureStorage);

  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    try {
      final response = await _dio.post(
        Apis.postLogin,
        data: dto.toJson(),
        options: Options(extra: {'skipAuthToken': true}),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final result = LoginResponseDto.fromJson(data);

      await _secureStorage.saveAccessToken(result.accessToken);
      await _secureStorage.saveRefreshToken(result.refreshToken);
      await _secureStorage.saveUserId(result.member.memberId);
      await _secureStorage.saveUserName(result.member.name);

      return result;
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '로그인에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }

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

  Future<void> signup(SignupRequestDto dto) async {
    try {
      await _dio.post(
        Apis.postSignup,
        data: dto.toJson(),
        options: Options(extra: {'skipAuthToken': true}),
      );
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '회원가입에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<void> sendVerificationCode(String phone) async {
    try {
      await _dio.post(
        Apis.sendPhoneNumber,
        data: {'phone': phone},
        options: Options(extra: {'skipAuthToken': true}),
      );
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '인증번호 발송에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<void> verifyPhone(String phone, String code) async {
    try {
      await _dio.post(
        Apis.postPhoneVerify,
        data: {'phone': phone, 'code': code},
        options: Options(extra: {'skipAuthToken': true}),
      );
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '인증번호 확인에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<bool> checkId(String loginId) async {
    try {
      final response = await _dio.get(
        Apis.getCheckId,
        queryParameters: {'loginId': loginId},
        options: Options(extra: {'skipAuthToken': true}),
      );
      return response.data['data']['available'] as bool;
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '아이디 확인에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }
}
