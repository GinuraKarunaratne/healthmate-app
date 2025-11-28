class Goal {
  final int? id;
  final int dailyStepGoal;
  final int dailyWaterGoalMl;
  final double targetWeight;

  Goal({
    this.id,
    required this.dailyStepGoal,
    required this.dailyWaterGoalMl,
    required this.targetWeight,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'daily_step_goal': dailyStepGoal,
      'daily_water_goal_ml': dailyWaterGoalMl,
      'target_weight': targetWeight,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as int?,
      dailyStepGoal: map['daily_step_goal'] as int,
      dailyWaterGoalMl: map['daily_water_goal_ml'] as int,
      targetWeight: (map['target_weight'] as num).toDouble(),
    );
  }

  Goal copyWith({
    int? id,
    int? dailyStepGoal,
    int? dailyWaterGoalMl,
    double? targetWeight,
  }) {
    return Goal(
      id: id ?? this.id,
      dailyStepGoal: dailyStepGoal ?? this.dailyStepGoal,
      dailyWaterGoalMl: dailyWaterGoalMl ?? this.dailyWaterGoalMl,
      targetWeight: targetWeight ?? this.targetWeight,
    );
  }
}
