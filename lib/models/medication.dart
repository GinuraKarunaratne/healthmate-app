class Medication {
  final int? id;
  final String name;
  final String dosage;
  final String frequency; // 'daily', 'twice_daily', 'weekly', etc.
  final String timeOfDay; // e.g., 'morning', 'afternoon', 'evening', 'night'
  final bool isActive;
  final DateTime createdAt;
  final String? notes;

  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.timeOfDay,
    this.isActive = true,
    DateTime? createdAt,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'timeOfDay': timeOfDay,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      frequency: map['frequency'] as String,
      timeOfDay: map['timeOfDay'] as String,
      isActive: (map['isActive'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      notes: map['notes'] as String?,
    );
  }

  Medication copyWith({
    int? id,
    String? name,
    String? dosage,
    String? frequency,
    String? timeOfDay,
    bool? isActive,
    DateTime? createdAt,
    String? notes,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
