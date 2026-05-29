import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';

// 약 데이터 모델
class MedicationModel {
  final String id;
  final String name;
  final String time;

  MedicationModel({
    required this.id,
    required this.name,
    required this.time,
  });
}

// 일정 화면 뷰모델
class ScheduleViewModel extends ChangeNotifier {
  final _storage = getIt<SecureStorageRepository>();
  final DateTime _today = DateTime.now();
  String _elderName = '어르신';

  // 샘플 데이터 (이미지 기준: 1. 혈압약 09:00)
  final List<MedicationModel> _medications = [
    MedicationModel(id: '1', name: '혈압약', time: '09:00'),
  ];

  String get todayText => _formatDate(_today);
  String get memberName => _elderName;
  String get greeting => '오늘도 따뜻한 하루 보내세요';
  List<MedicationModel> get medications => _medications;

  Future<void> loadHeaderData() async {
    final elderName = await _storage.readElderName();
    if (elderName != null && elderName.isNotEmpty) {
      _elderName = elderName;
      notifyListeners();
    }
  }

  // 약 추가 기능 (추가하기 버튼 클릭 시)
  void addMedication(String name, String time) {
    final newId = (DateTime.now().millisecondsSinceEpoch).toString();
    _medications.add(MedicationModel(id: newId, name: name, time: time));
    notifyListeners(); // UI 업데이트 알림
  }

  // 약 삭제 기능 (삭제 텍스트 버튼 클릭 시)
  void removeMedication(String id) {
    _medications.removeWhere((med) => med.id == id);
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
}
