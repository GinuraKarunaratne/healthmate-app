import 'package:flutter/foundation.dart';
import '../models/sleep_session.dart';
import '../services/database_helper.dart';

class SleepProvider with ChangeNotifier {
  List<SleepSession> _sessions = [];
  bool _isLoading = false;
  String? _error;

  List<SleepSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSessions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _sessions = await DatabaseHelper.instance.getAllSleepSessions();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load sleep sessions: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSession(SleepSession session) async {
    try {
      await DatabaseHelper.instance.createSleepSession(session);
      await loadSessions();
      return true;
    } catch (e) {
      _error = 'Failed to add sleep session: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSession(int id) async {
    try {
      await DatabaseHelper.instance.deleteSleepSession(id);
      await loadSessions();
      return true;
    } catch (e) {
      _error = 'Failed to delete sleep session: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  double getAverageDuration() {
    if (_sessions.isEmpty) return 0;
    final total = _sessions.fold(0, (sum, s) => sum + s.durationMinutes);
    return total / _sessions.length;
  }

  double getAverageQuality() {
    if (_sessions.isEmpty) return 0;
    final total = _sessions.fold(0, (sum, s) => sum + s.quality);
    return total / _sessions.length;
  }

  Future<List<SleepSession>> getLast7DaysSessions() async {
    try {
      return await DatabaseHelper.instance.getLast7DaysSleepSessions();
    } catch (e) {
      _error = 'Failed to load weekly sessions: ${e.toString()}';
      return [];
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
