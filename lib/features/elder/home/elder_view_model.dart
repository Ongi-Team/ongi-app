import 'package:flutter/material.dart';
import 'package:ongi_app/core/di/service_locator.dart';
import 'package:ongi_app/data/dto/response/daily_medication_response_dto.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:ongi_app/data/services/medicine_service.dart';

enum MedicationReminderStatus { active, upcoming }

class ElderViewModel extends ChangeNotifier {
  final _medicineService = getIt<MedicineService>();
  final _storage = getIt<SecureStorageRepository>();
  final DateTime _today = DateTime.now();

  MedicationReminderStatus _status = MedicationReminderStatus.upcoming;
  String _memberName = '어르신';
  DailyMedicationResponseDto? _currentSchedule;
  List<DailyMedicationResponseDto> _allSchedules = [];
  bool _isScheduleLoading = false;
  String? _scheduleErrorMessage;

  String get todayText => _formatDate(_today);
  String get memberName => _memberName;
  String get greeting => '오늘도 따뜻한 하루 보내세요';
  MedicationReminderStatus get status => _status;
  DailyMedicationResponseDto? get currentSchedule => _currentSchedule;
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
      final now = DateTime.now();
      final today =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final schedules =
          await _medicineService.getDailyMedications(date: today);
      // result == null(예정) 또는 MISSED(미복약)만 표시, TAKEN(복약 완료)은 제외
      _allSchedules =
          schedules.where((s) => s.result != 'TAKEN').toList();
      _selectClosestSchedule(now);
    } catch (e) {
      _allSchedules = [];
      _currentSchedule = null;
      _status = MedicationReminderStatus.upcoming;
      _scheduleErrorMessage = '복약 일정을 불러오지 못했습니다.';
    } finally {
      _isScheduleLoading = false;
      notifyListeners();
    }
  }

  // 우선순위:
  // 1) 지금으로부터 10분 이내에 지난 약 (지금 드세요) → active
  // 2) 그 외 가장 가까운 약 (미래면 upcoming, 과거면 active)
  void _selectClosestSchedule(DateTime now) {
    if (_allSchedules.isEmpty) {
      _currentSchedule = null;
      _status = MedicationReminderStatus.upcoming;
      return;
    }

    final tenMinutesAgo = now.subtract(const Duration(minutes: 10));

    // 10분 이내 과거 일정 중 가장 최근 것 우선
    final urgent = _allSchedules.where((s) {
      final t = _toTodayDateTime(s.scheduledTime, now);
      return t != null && !t.isAfter(now) && !t.isBefore(tenMinutesAgo);
    }).toList()
      ..sort((a, b) {
        final aTime = _toTodayDateTime(a.scheduledTime, now)!;
        final bTime = _toTodayDateTime(b.scheduledTime, now)!;
        return bTime.compareTo(aTime);
      });

    if (urgent.isNotEmpty) {
      _currentSchedule = urgent.first;
      _status = MedicationReminderStatus.active;
      return;
    }

    // 긴급 없으면 절대 시간 차이 최소인 일정
    DailyMedicationResponseDto? closest;
    Duration? minDiff;

    for (final schedule in _allSchedules) {
      final scheduledTime = _toTodayDateTime(schedule.scheduledTime, now);
      if (scheduledTime == null) continue;
      final diff = now.difference(scheduledTime).abs();
      if (minDiff == null || diff < minDiff) {
        minDiff = diff;
        closest = schedule;
      }
    }

    _currentSchedule = closest;
    if (closest != null) {
      final scheduledTime = _toTodayDateTime(closest.scheduledTime, now)!;
      _status = scheduledTime.isAfter(now)
          ? MedicationReminderStatus.upcoming
          : MedicationReminderStatus.active;
    } else {
      _status = MedicationReminderStatus.upcoming;
    }
  }

  // '알겠어요' 버튼: 복약 기록 서버 전송 후 다음 일정으로 이동
  Future<void> confirmMedication() async {
    if (_status == MedicationReminderStatus.active &&
        _currentSchedule != null) {
      final confirmed = _currentSchedule!;
      final now = DateTime.now();

      // 낙관적 UI 업데이트 먼저
      _currentSchedule = _findNextSchedule(now);
      _status = MedicationReminderStatus.upcoming;
      notifyListeners();

      // deviceId / slotNumber가 있을 때만 서버에 기록
      if (confirmed.deviceId != null && confirmed.slotNumber != null) {
        try {
          await _medicineService.syncMedicationTaken(
            deviceId: confirmed.deviceId!,
            dispenserSlot: confirmed.slotNumber!,
          );
        } catch (_) {
          // 서버 오류는 조용히 무시 — UI는 이미 다음 일정으로 이동됨
        }
      }
    }
  }

  // now 이후의 일정 중 가장 이른 것을 반환
  DailyMedicationResponseDto? _findNextSchedule(DateTime now) {
    final future = _allSchedules.where((s) {
      final t = _toTodayDateTime(s.scheduledTime, now);
      return t != null && t.isAfter(now);
    }).toList()
      ..sort((a, b) {
        final aTime = _toTodayDateTime(a.scheduledTime, now)!;
        final bTime = _toTodayDateTime(b.scheduledTime, now)!;
        return aTime.compareTo(bTime);
      });

    return future.isNotEmpty ? future.first : null;
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final weekday = weekdays[date.weekday - 1];
    return '$year. $month. $day($weekday)';
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
