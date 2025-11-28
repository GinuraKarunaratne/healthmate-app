import 'package:flutter/foundation.dart';
import '../models/goal.dart';
import '../services/database_helper.dart';

class GoalsProvider with ChangeNotifier {
  Goal? _goal;
  bool _isLoading = false;
  String? _error;

  Goal? get goal => _goal;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get dailyStepGoal => _goal?.dailyStepGoal ?? 10000;
  int get dailyWaterGoalMl => _goal?.dailyWaterGoalMl ?? 2000;
  double get targetWeight => _goal?.targetWeight ?? 70.0;

  Future<void> loadGoal() async {
    _isLoading = true;
    notifyListeners();

    try {
      _goal = await DatabaseHelper.instance.getGoal();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load goal: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateGoal(int stepGoal, int waterGoal, double weight) async {
    try {
      final newGoal = Goal(
        id: _goal?.id,
        dailyStepGoal: stepGoal,
        dailyWaterGoalMl: waterGoal,
        targetWeight: weight,
      );

      await DatabaseHelper.instance.updateGoal(newGoal);
      await loadGoal();
      return true;
    } catch (e) {
      _error = 'Failed to update goal: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  double getStepProgress(int currentSteps) {
    if (dailyStepGoal == 0) return 0;
    return (currentSteps / dailyStepGoal).clamp(0.0, 1.0);
  }

  double getWaterProgress(int currentWater) {
    if (dailyWaterGoalMl == 0) return 0;
    return (currentWater / dailyWaterGoalMl).clamp(0.0, 1.0);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
