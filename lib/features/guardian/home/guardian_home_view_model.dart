import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:ongi_app/data/services/medicine_service.dart';

class GuardianHomeViewModel extends ChangeNotifier {
  GuardianHomeViewModel({DateTime? now}) : _today = now ?? DateTime.now();

  final _medicineService = getIt<MedicineService>();
  final _storage = getIt<SecureStorageRepository>();
  final DateTime _today;
  final List<MedicationItem> _medications = [];

  bool _isMedicationLoading = false;
  String? _medicationErrorMessage;
  String _elderName = '어르신';

  String get todayText => _formatDate(_today);
  String get queryDate => _formatQueryDate(_today);
  String get memberName => _elderName;
  String get greeting => '오늘도 따뜻한 하루 보내세요';
  bool get isMedicationLoading => _isMedicationLoading;
  String? get medicationErrorMessage => _medicationErrorMessage;
  List<MedicationItem> get medications => List.unmodifiable(_medications);

  List<DeviceStatusItem> get deviceStatuses => const [
        DeviceStatusItem(title: '디바이스 정상 작동', isNormal: true),
        DeviceStatusItem(title: '네트워크 정상 연결', isNormal: true),
      ];

  Future<void> loadMedications() async {
    _isMedicationLoading = true;
    _medicationErrorMessage = null;
    notifyListeners();

    try {
      final elderId = await _storage.getElderId();
      final elderName = await _storage.readElderName();
      if (elderName != null && elderName.isNotEmpty) {
        _elderName = elderName;
      }

      if (elderId == null) {
        _medications.clear();
        _medicationErrorMessage = '어르신 정보를 찾을 수 없습니다.';
        return;
      }

      final records = await _medicineService.getMedicationRecords(
        elderId: elderId,
        date: queryDate,
      );

      _medications
        ..clear()
        ..addAll(records.map(
          (record) => MedicationItem(
            title: record.medicineName,
            time: _formatScheduledTime(record.scheduledTime),
            isChecked: record.result == 'TAKEN',
          ),
        ));
    } catch (e) {
      _medications.clear();
      _medicationErrorMessage = '복약 기록을 불러오지 못했습니다.';
    } finally {
      _isMedicationLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final weekday = weekdays[date.weekday - 1];

    return '$year. $month. $day($weekday)';
  }

  String _formatQueryDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String _formatScheduledTime(String scheduledTime) {
    final parts = scheduledTime.split(':');
    if (parts.length < 2) return scheduledTime;
    return '${parts[0]}:${parts[1]}';
  }
}

class MedicationItem {
  final String title;
  final String time;
  final bool isChecked;

  const MedicationItem({
    required this.title,
    required this.time,
    required this.isChecked,
  });
}

class DeviceStatusItem {
  final String title;
  final bool isNormal;

  const DeviceStatusItem({
    required this.title,
    required this.isNormal,
  });
}
