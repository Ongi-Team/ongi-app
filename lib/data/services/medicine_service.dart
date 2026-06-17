import 'package:dio/dio.dart';
import 'package:ongi_app/core/constants/apis.dart';
import 'package:ongi_app/data/dto/request/medication_sync_request_dto.dart';
import 'package:ongi_app/data/dto/response/daily_medication_response_dto.dart';
import 'package:ongi_app/data/dto/response/medicine_schedule_response_dto.dart';
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

  Future<List<DailyMedicationResponseDto>> getDailyMedications({
    required String date,
  }) async {
    try {
      final response = await _dio.get(
        Apis.getDailyMedications,
        queryParameters: {
          'date': date,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) =>
              DailyMedicationResponseDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '복약 기록을 불러오지 못했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<void> syncMedicationTaken({
    required int deviceId,
    required int dispenserSlot,
  }) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      await _dio.post(
        Apis.getMedications,
        data: {
          'records': [
            MedicationSyncRequestDto(
              deviceId: deviceId,
              dispenserSlot: dispenserSlot,
              result: 'TAKEN',
              recordedAt: now,
            ).toJson(),
          ],
        },
      );
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '복약 기록 저장에 실패했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<List<MedicineScheduleResponseDto>> getMedicineSchedules() async {
    try {
      final response = await _dio.get(Apis.getMedicineSchedules);
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) =>
              MedicineScheduleResponseDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '복약 일정을 불러오지 못했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<void> saveMedicineSchedules({
    required List<Map<String, String>> schedules,
  }) async {
    try {
      await _dio.post(
        Apis.getMedicineSchedules,
        data: {
          'schedules': schedules,
        },
      );
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '복약 일정을 저장하지 못했습니다.',
        e.response?.statusCode,
      );
    }
  }

  Future<void> deleteMedicineSchedule({required int medicineId}) async {
    try {
      await _dio.delete('${Apis.getMedicineSchedules}/$medicineId');
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?['message'] ?? '복약 일정을 삭제하지 못했습니다.',
        e.response?.statusCode,
      );
    }
  }
}
