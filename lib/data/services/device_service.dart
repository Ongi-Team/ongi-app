import 'package:dio/dio.dart';
import 'package:ongi_app/core/constants/apis.dart';
import 'package:ongi_app/data/network/api_exception.dart';

class DeviceService {
  final Dio _dio;

  DeviceService(this._dio);

  Future<void> openAllSlots() async {
    try {
      await _dio.post(Apis.openAllDeviceSlots);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '약통 열기 명령을 전달하지 못했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<void> closeAllSlots() async {
    try {
      await _dio.post(Apis.closeAllDeviceSlots);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '약통 닫기 명령을 전달하지 못했습니다.',
        e.response?.statusCode,
      );
    }
  }
}
