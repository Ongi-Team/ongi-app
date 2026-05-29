class MedicineScheduleResponseDto {
  final int? medicineId;
  final String medicineName;
  final String scheduledTime;
  final int? slotNumber;
  final int? deviceId;

  const MedicineScheduleResponseDto({
    this.medicineId,
    required this.medicineName,
    required this.scheduledTime,
    this.slotNumber,
    this.deviceId,
  });

  factory MedicineScheduleResponseDto.fromJson(Map<String, dynamic> json) {
    return MedicineScheduleResponseDto(
      medicineId: json['medicineId'] as int? ??
          json['scheduleId'] as int? ??
          json['medicineScheduleId'] as int? ??
          json['id'] as int?,
      medicineName:
          (json['name'] as String?) ?? (json['medicineName'] as String),
      scheduledTime: json['scheduledTime'] as String,
      slotNumber: json['slotNumber'] as int?,
      deviceId: json['deviceId'] as int?,
    );
  }
}
