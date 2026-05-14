class DoseHistory {
  final int? id;
  final int medicineId;
  final String scheduledDate;
  final bool taken;

  DoseHistory({
    this.id,
    required this.medicineId,
    required this.scheduledDate,
    required this.taken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineId': medicineId,
      'scheduledDate': scheduledDate,
      'taken': taken ? 1 : 0,
    };
  }

  factory DoseHistory.fromMap(Map<String, dynamic> map) {
    return DoseHistory(
      id: map['id'],
      medicineId: map['medicineId'],
      scheduledDate: map['scheduledDate'],
      taken: map['taken'] == 1,
    );
  }
}
