import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:ongi_app/data/services/medicine_service.dart';

// 약 데이터 모델
class MedicationModel {
  final String id;
  final int? medicineId;
  final String name;
  final String time;

  MedicationModel({
    required this.id,
    this.medicineId,
    required this.name,
    required this.time,
  });
}

// 일정 화면 뷰모델
class ScheduleViewModel extends ChangeNotifier {
  final _medicineService = getIt<MedicineService>();
  final _storage = getIt<SecureStorageRepository>();
  final DateTime _today = DateTime.now();
  String _elderName = '어르신';

  final List<MedicationModel> _medications = [];
  bool _isMedicationLoading = false;
  String? _medicationErrorMessage;

  String get todayText => _formatDate(_today);
  String get memberName => _elderName;
  String get greeting => '오늘도 따뜻한 하루 보내세요';
  bool get isMedicationLoading => _isMedicationLoading;
  String? get medicationErrorMessage => _medicationErrorMessage;
  List<MedicationModel> get medications => List.unmodifiable(_medications);

  Future<void> loadInitialData() async {
    await Future.wait([
      loadHeaderData(),
      loadMedications(),
    ]);
  }

  Future<void> loadHeaderData() async {
    final elderName = await _storage.readElderName();
    if (elderName != null && elderName.isNotEmpty) {
      _elderName = elderName;
      notifyListeners();
    }
  }

  Future<void> loadMedications() async {
    _isMedicationLoading = true;
    _medicationErrorMessage = null;
    notifyListeners();

    try {
      final schedules = await _medicineService.getMedicineSchedules();
      _medications
        ..clear()
        ..addAll(
          schedules.asMap().entries.map((entry) {
            final index = entry.key;
            final schedule = entry.value;
            return MedicationModel(
              id: (schedule.medicineId ?? index).toString(),
              medicineId: schedule.medicineId,
              name: schedule.medicineName,
              time: _formatScheduledTime(schedule.scheduledTime),
            );
          }),
        );
    } catch (e) {
      _medications.clear();
      _medicationErrorMessage = '약 일정을 불러오지 못했습니다.';
    } finally {
      _isMedicationLoading = false;
      notifyListeners();
    }
  }

  // 약 추가 기능 (추가하기 버튼 클릭 시)
  Future<void> addMedication(String name, String time) async {
    final schedules = [
      ..._medications.map(
        (medication) => {
          'name': medication.name,
          'scheduledTime': _formatRequestTime(medication.time),
        },
      ),
      {
        'name': name,
        'scheduledTime': _formatRequestTime(time),
      },
    ];

    await _medicineService.saveMedicineSchedules(schedules: schedules);
    await loadMedications();
  }

  // 약 삭제 기능 (삭제 텍스트 버튼 클릭 시)
  Future<void> removeMedication(MedicationModel medication) async {
    final medicineId = medication.medicineId ?? int.tryParse(medication.id);
    if (medicineId == null) {
      _medications.removeWhere((med) => med.id == medication.id);
      notifyListeners();
      return;
    }

    await _medicineService.deleteMedicineSchedule(medicineId: medicineId);
    _medications.removeWhere((med) => med.id == medication.id);
    notifyListeners(); // UI 업데이트 알림
  }

  // 약통 열기 버튼 기능
  void openPillBox() {
    // TODO: 하드웨어 디바이스 연동 또는 API 호출 로직
    debugPrint('약통 열기 명령 전송');
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final weekday = weekdays[date.weekday - 1];

    return '$year. $month. $day($weekday)';
  }

  String _formatScheduledTime(String scheduledTime) {
    final parts = scheduledTime.split(':');
    if (parts.length < 2) return scheduledTime;
    return '${parts[0]}:${parts[1]}';
  }

  String _formatRequestTime(String time) {
    final parts = time.split(':');
    if (parts.length >= 3) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:${parts[2].padLeft(2, '0')}';
    }
    if (parts.length == 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:00';
    }
    return time;
  }
}
