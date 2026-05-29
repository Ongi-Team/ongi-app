import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';

// 복약 위젯의 상태 정의
enum MedicationReminderStatus { active, upcoming }

class ElderViewModel extends ChangeNotifier {
  final _storage = getIt<SecureStorageRepository>();
  final DateTime _today = DateTime.now();

  // 현재 복약 위젯의 상태 (테스트를 위해 기본값을 active로 설정)
  MedicationReminderStatus _status = MedicationReminderStatus.active;
  String _memberName = '어르신';

  String get todayText => _formatDate(_today);
  String get memberName => _memberName;
  String get greeting => '오늘도 따뜻한 하루 보내세요';
  MedicationReminderStatus get status => _status;

  Future<void> loadHeaderData() async {
    final userName = await _storage.readUserName();
    if (userName != null && userName.isNotEmpty) {
      _memberName = userName;
      notifyListeners();
    }
  }

  // 상태 전환 메서드 (실제로는 서버 시간이나 로컬 알람과 연동)
  void toggleStatus() {
    _status = _status == MedicationReminderStatus.active
        ? MedicationReminderStatus.upcoming
        : MedicationReminderStatus.active;
    notifyListeners();
  }

  // '알겠어요' 버튼 클릭 시 로직
  void confirmMedication() {
    if (_status == MedicationReminderStatus.active) {
      debugPrint('복약 확인 완료 - 상태를 다음 복용으로 변경합니다.');
      _status = MedicationReminderStatus.upcoming;
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
}
