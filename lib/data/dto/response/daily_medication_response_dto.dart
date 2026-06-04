class DailyMedicationResponseDto {
  final int medicineId;
  final String medicineName;
  final String scheduledTime;
  final int? slotNumber;
  final int? deviceId;
  final bool taken;
  final String? result;
  final DateTime? recordedAt;

  const DailyMedicationResponseDto({
    required this.medicineId,
    required this.medicineName,
    required this.scheduledTime,
    this.slotNumber,
    this.deviceId,
    required this.taken,
    this.result,
    this.recordedAt,
  });

  factory DailyMedicationResponseDto.fromJson(Map<String, dynamic> json) {
    return DailyMedicationResponseDto(
      medicineId: json['medicineId'] as int,
      medicineName: json['medicineName'] as String,
      scheduledTime: json['scheduledTime'] as String,
      slotNumber: json['slotNumber'] as int?,
      deviceId: json['deviceId'] as int?,
      taken: json['taken'] as bool? ?? false,
      result: json['result'] as String?,
      recordedAt: json['recordedAt'] == null
          ? null
          : DateTime.tryParse(json['recordedAt'] as String),
    );
  }
}
