import 'package:dio/dio.dart';
import 'package:ongi_app/core/constants/apis.dart';
import 'package:ongi_app/data/dto/request/login_request_dto.dart';
import 'package:ongi_app/data/dto/request/login_session_request_dto.dart';
import 'package:ongi_app/data/dto/request/signup_request_dto.dart';
import 'package:ongi_app/data/dto/response/login_response_dto.dart';
import 'package:ongi_app/data/dto/response/login_session_response_dto.dart';
import 'package:ongi_app/data/network/api_exception.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';

class AuthService {
  final Dio _dio;
  final SecureStorageRepository _secureStorage;

  AuthService(this._dio, this._secureStorage);

  Future<LoginSessionResponseDto> createLoginSession(
    LoginSessionRequestDto dto,
  ) async {
    try {
      final response = await _dio.post(
        Apis.postLogin,
        data: dto.toJson(),
        options: Options(extra: {'skipAuthToken': true}),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return LoginSessionResponseDto.fromJson(data);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '로그인에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    try {
      final response = await _dio.post(
        Apis.postLoginMode,
        data: dto.toJson(),
        options: Options(extra: {'skipAuthToken': true}),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final result = LoginResponseDto.fromJson(data);

      await _secureStorage.saveAccessToken(result.accessToken);
      await _secureStorage.saveRefreshToken(result.refreshToken);
      await _secureStorage.saveRole(result.loginMode);
      final member = result.member;
      final elder = result.elder;
      if (elder != null) {
        await _secureStorage.saveElderId(elder.elderId);
        await _secureStorage.saveElderName(elder.name);
      }
      if (member != null) {
        await _secureStorage.saveUserId(member.memberId);
        await _secureStorage.saveUserName(member.name);
      } else if (elder != null) {
        await _secureStorage.saveUserId(elder.elderId);
        await _secureStorage.saveUserName(elder.name);
      }

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
    final loginMode = await _secureStorage.readRole();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _secureStorage.deleteAuthData();
      throw Exception('리프레시 토큰이 없습니다.');
    }
    if (loginMode == null || loginMode.isEmpty) {
      await _secureStorage.deleteAuthData();
      throw Exception('로그인 모드가 없습니다.');
    }

    try {
      final response = await _dio.post(
        Apis.reissueToken,
        data: {
          'refreshToken': refreshToken,
          'loginMode': loginMode,
        },
        options: Options(extra: {'skipAuthToken': true}),
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final newAccessToken = data['accessToken'] as String?;
      final newRefreshToken = data['refreshToken'] as String?;

      if (newAccessToken == null || newRefreshToken == null) {
        throw Exception('재발급된 토큰이 없습니다.');
      }

      await _secureStorage.saveAccessToken(newAccessToken);
      await _secureStorage.saveRefreshToken(newRefreshToken);
    } on DioException catch (e) {
      await _secureStorage.deleteAuthData();
      throw ApiException(
        e.response?.data?['message'] ?? '토큰 재발급에 실패했습니다.',
        e.response?.statusCode,
      );
    } catch (e) {
      await _secureStorage.deleteAuthData();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(Apis.postLogout);
      await _secureStorage.deleteAuthData();
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '로그아웃에 실패했습니다.',
        e.response?.statusCode,
      );
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
