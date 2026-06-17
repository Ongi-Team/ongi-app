class MedicationSyncRequestDto {
  final int deviceId;
  final int dispenserSlot;
  final String result;
  final String recordedAt;

  const MedicationSyncRequestDto({
    required this.deviceId,
    required this.dispenserSlot,
    required this.result,
    required this.recordedAt,
  });

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'dispenserSlot': dispenserSlot,
        'result': result,
        'recordedAt': recordedAt,
      };
}
