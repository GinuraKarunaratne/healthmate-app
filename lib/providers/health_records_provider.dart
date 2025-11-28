import '../models/health_record.dart';
import '../services/database_helper.dart';
import '../core/helpers.dart';

// NO MORE CHANGENOTIFIER BULLSHIT
// This is now a simple service that just returns data
class HealthRecordsProvider {
  // Just direct data access, no state management crap

  Future<List<HealthRecord>> loadRecords() async {
    try {
      return await DatabaseHelper.instance.getAllHealthRecords();
    } catch (e) {
      print('Failed to load records: $e');
      return [];
    }
  }

  Future<HealthRecord?> loadTodayRecord() async {
    try {
      final today = DateHelper.getToday();
      return await DatabaseHelper.instance.getHealthRecordByDate(today);
    } catch (e) {
      print('Failed to load today\'s record: $e');
      return null;
    }
  }

  Future<List<HealthRecord>> getLast7DaysRecords() async {
    try {
      return await DatabaseHelper.instance.getLast7DaysRecords();
    } catch (e) {
      print('Failed to load weekly records: $e');
      return [];
    }
  }

  Future<List<HealthRecord>> getRecordsByDateRange(String startDate, String endDate) async {
    try {
      return await DatabaseHelper.instance.getHealthRecordsByDateRange(startDate, endDate);
    } catch (e) {
      print('Failed to filter records: $e');
      return [];
    }
  }

  Future<bool> addRecord(HealthRecord record) async {
    try {
      await DatabaseHelper.instance.createHealthRecord(record);
      return true;
    } catch (e) {
      print('Failed to add record: $e');
      return false;
    }
  }

  Future<bool> updateRecord(HealthRecord record) async {
    try {
      await DatabaseHelper.instance.updateHealthRecord(record);
      return true;
    } catch (e) {
      print('Failed to update record: $e');
      return false;
    }
  }

  Future<bool> deleteRecord(int id) async {
    try {
      await DatabaseHelper.instance.deleteHealthRecord(id);
      return true;
    } catch (e) {
      print('Failed to delete record: $e');
      return false;
    }
  }

  // Pure functions - no state
  Map<String, int> getTodayStats(HealthRecord? todayRecord) {
    if (todayRecord == null) {
      return {'steps': 0, 'calories': 0, 'water': 0};
    }
    return {
      'steps': todayRecord.steps,
      'calories': todayRecord.calories,
      'water': todayRecord.water,
    };
  }

  Map<String, double> getWeeklyAverages(List<HealthRecord> weekRecords) {
    if (weekRecords.isEmpty) {
      return {'steps': 0, 'calories': 0, 'water': 0};
    }

    final totalSteps = weekRecords.fold(0, (sum, r) => sum + r.steps);
    final totalCalories = weekRecords.fold(0, (sum, r) => sum + r.calories);
    final totalWater = weekRecords.fold(0, (sum, r) => sum + r.water);

    return {
      'steps': totalSteps / weekRecords.length,
      'calories': totalCalories / weekRecords.length,
      'water': totalWater / weekRecords.length,
    };
  }
}
