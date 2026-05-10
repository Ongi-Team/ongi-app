import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ongi_app/core/constants/apis.dart';
import 'package:ongi_app/data/network/api_exception.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';

class MemberService {
  final Dio _dio;
  final SecureStorageRepository _secureStorage;

  MemberService(this._dio, this._secureStorage);

  Future<void> updateFcmToken() async {
    final fcmToken = await _secureStorage.readFcmToken();
    if (fcmToken == null) return;

    try {
      await _dio.patch(
        Apis.fcmToken,
        data: {
          'fcmToken': fcmToken,
          'osType': Platform.isIOS ? 'IOS' : 'ANDROID',
        },
      );
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? 'FCM 토큰 갱신에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<void> deleteFcmToken() async {
    try {
      await _dio.delete(Apis.fcmToken);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? 'FCM 토큰 삭제에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }
}
