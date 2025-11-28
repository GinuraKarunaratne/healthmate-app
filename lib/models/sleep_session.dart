class SleepSession {
  final int? id;
  final int startTime;
  final int endTime;
  final int durationMinutes;
  final int quality;
  final String date;

  SleepSession({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.quality,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_time': startTime,
      'end_time': endTime,
      'duration_minutes': durationMinutes,
      'quality': quality,
      'date': date,
    };
  }

  factory SleepSession.fromMap(Map<String, dynamic> map) {
    return SleepSession(
      id: map['id'] as int?,
      startTime: map['start_time'] as int,
      endTime: map['end_time'] as int,
      durationMinutes: map['duration_minutes'] as int,
      quality: map['quality'] as int,
      date: map['date'] as String,
    );
  }
}
