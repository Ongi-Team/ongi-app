import 'package:dio/dio.dart';
import 'package:ongi_app/core/constants/apis.dart';
import 'package:ongi_app/data/dto/response/medication_record_response_dto.dart';
import 'package:ongi_app/data/network/api_exception.dart';

class MedicineService {
  final Dio _dio;

  MedicineService(this._dio);

  Future<List<MedicationRecordResponseDto>> getMedicationRecords({
    required int elderId,
    required String date,
  }) async {
    try {
      final response = await _dio.get(
        Apis.getMedications,
        queryParameters: {
          'elderId': elderId,
          'date': date,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) =>
              MedicationRecordResponseDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '복약 기록을 불러오지 못했습니다.',
        e.response?.statusCode,
      );
    }
  }
}
