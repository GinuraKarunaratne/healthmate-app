class DetailedRecord {
  final int? id;
  final String type;
  final double value;
  final String date;
  final int timestamp;
  final String? notes;

  DetailedRecord({
    this.id,
    required this.type,
    required this.value,
    required this.date,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'date': date,
      'timestamp': timestamp,
      'notes': notes,
    };
  }

  factory DetailedRecord.fromMap(Map<String, dynamic> map) {
    return DetailedRecord(
      id: map['id'] as int?,
      type: map['type'] as String,
      value: (map['value'] as num).toDouble(),
      date: map['date'] as String,
      timestamp: map['timestamp'] as int,
      notes: map['notes'] as String?,
    );
  }
}
