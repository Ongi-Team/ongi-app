import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/data/dto/response/medicine_schedule_response_dto.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:ongi_app/data/services/medicine_service.dart';

// 복약 위젯의 상태 정의
enum MedicationReminderStatus { active, upcoming }

class ElderViewModel extends ChangeNotifier {
  final _medicineService = getIt<MedicineService>();
  final _storage = getIt<SecureStorageRepository>();
  final DateTime _today = DateTime.now();

  MedicationReminderStatus _status = MedicationReminderStatus.upcoming;
  String _memberName = '어르신';
  MedicineScheduleResponseDto? _currentSchedule;
  bool _isScheduleLoading = false;
  String? _scheduleErrorMessage;

  String get todayText => _formatDate(_today);
  String get memberName => _memberName;
  String get greeting => '오늘도 따뜻한 하루 보내세요';
  MedicationReminderStatus get status => _status;
  MedicineScheduleResponseDto? get currentSchedule => _currentSchedule;
  bool get isScheduleLoading => _isScheduleLoading;
  String? get scheduleErrorMessage => _scheduleErrorMessage;
  String get medicineName => _currentSchedule?.medicineName ?? '복약 일정';
  String get scheduledTimeText =>
      _formatDisplayTime(_currentSchedule?.scheduledTime);
  String get reminderMessage =>
      _status == MedicationReminderStatus.active ? '지금 드세요' : '다음에 복용';

  Future<void> loadHeaderData() async {
    final userName = await _storage.readUserName();
    if (userName != null && userName.isNotEmpty) {
      _memberName = userName;
      notifyListeners();
    }
  }

  Future<void> loadMedicineSchedules() async {
    _isScheduleLoading = true;
    _scheduleErrorMessage = null;
    notifyListeners();

    try {
      final schedules = await _medicineService.getMedicineSchedules();
      final now = DateTime.now();
      final pastSchedule = _findLatestPastSchedule(schedules, now);
      _currentSchedule = pastSchedule ?? _findNextSchedule(schedules, now);
      _status = pastSchedule == null
          ? MedicationReminderStatus.upcoming
          : MedicationReminderStatus.active;
    } catch (e) {
      _currentSchedule = null;
      _status = MedicationReminderStatus.upcoming;
      _scheduleErrorMessage = '복약 일정을 불러오지 못했습니다.';
    } finally {
      _isScheduleLoading = false;
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
      _currentSchedule = null;
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

  MedicineScheduleResponseDto? _findLatestPastSchedule(
    List<MedicineScheduleResponseDto> schedules,
    DateTime now,
  ) {
    final pastSchedules = schedules.where((schedule) {
      final scheduledDateTime = _toTodayDateTime(schedule.scheduledTime, now);
      if (scheduledDateTime == null) return false;
      return !scheduledDateTime.isAfter(now);
    }).toList()
      ..sort((a, b) {
        final aTime = _toTodayDateTime(a.scheduledTime, now)!;
        final bTime = _toTodayDateTime(b.scheduledTime, now)!;
        return bTime.compareTo(aTime);
      });

    if (pastSchedules.isEmpty) return null;
    return pastSchedules.first;
  }

  MedicineScheduleResponseDto? _findNextSchedule(
    List<MedicineScheduleResponseDto> schedules,
    DateTime now,
  ) {
    final nextSchedules = schedules.where((schedule) {
      final scheduledDateTime = _toTodayDateTime(schedule.scheduledTime, now);
      if (scheduledDateTime == null) return false;
      return scheduledDateTime.isAfter(now);
    }).toList()
      ..sort((a, b) {
        final aTime = _toTodayDateTime(a.scheduledTime, now)!;
        final bTime = _toTodayDateTime(b.scheduledTime, now)!;
        return aTime.compareTo(bTime);
      });

    if (nextSchedules.isEmpty) return null;
    return nextSchedules.first;
  }

  DateTime? _toTodayDateTime(String scheduledTime, DateTime now) {
    final parts = scheduledTime.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    final second = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    if (hour == null || minute == null) return null;

    return DateTime(now.year, now.month, now.day, hour, minute, second);
  }

  String _formatDisplayTime(String? scheduledTime) {
    if (scheduledTime == null) return '--:--';

    final parts = scheduledTime.split(':');
    if (parts.length < 2) return scheduledTime;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return scheduledTime;

    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$period $displayHour:${minute.toString().padLeft(2, '0')}';
  }
}
