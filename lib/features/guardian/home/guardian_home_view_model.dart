import 'package:flutter/material.dart';

class GuardianHomeViewModel extends ChangeNotifier {
  GuardianHomeViewModel({DateTime? now}) : _today = now ?? DateTime.now();

  final DateTime _today;

  String get todayText => _formatDate(_today);
  String get memberName => '홍길동';
  String get greeting => '오늘도 따뜻한 하루 보내세요';

  List<MedicationItem> get medications => const [
        MedicationItem(title: '감기약', time: '08:30', isChecked: false),
        MedicationItem(title: '혈압약', time: '12:00', isChecked: true),
        MedicationItem(title: '비타민', time: '17:00', isChecked: true),
        MedicationItem(title: '감기약', time: '17:00', isChecked: false),
      ];

  List<DeviceStatusItem> get deviceStatuses => const [
        DeviceStatusItem(title: '디바이스 정상 작동', isNormal: true),
        DeviceStatusItem(title: '네트워크 정상 연결', isNormal: true),
      ];

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final weekday = weekdays[date.weekday - 1];

    return '$year. $month. $day($weekday)';
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
