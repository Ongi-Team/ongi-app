class MedicationRecordResponseDto {
  final int recordId;
  final String medicineName;
  final String scheduledTime;
  final String result;
  final DateTime? recordedAt;

  const MedicationRecordResponseDto({
    required this.recordId,
    required this.medicineName,
    required this.scheduledTime,
    required this.result,
    this.recordedAt,
  });

  factory MedicationRecordResponseDto.fromJson(Map<String, dynamic> json) {
    return MedicationRecordResponseDto(
      recordId: json['recordId'] as int,
      medicineName: json['medicineName'] as String,
      scheduledTime: json['scheduledTime'] as String,
      result: json['result'] as String,
      recordedAt: json['recordedAt'] == null
          ? null
          : DateTime.tryParse(json['recordedAt'] as String),
    );
  }
}
