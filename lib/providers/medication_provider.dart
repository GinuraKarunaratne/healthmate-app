import 'package:flutter/foundation.dart';
import '../models/medication.dart';
import '../services/database_helper.dart';

class MedicationProvider with ChangeNotifier {
  List<Medication> _medications = [];
  bool _isLoading = false;
  String? _error;

  List<Medication> get medications => _medications;
  List<Medication> get activeMedications =>
      _medications.where((m) => m.isActive).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMedications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query(
        'medications',
        orderBy: 'createdAt DESC',
      );

      _medications = maps.map((map) => Medication.fromMap(map)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load medications: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMedication(Medication medication) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert('medications', medication.toMap());

      final newMedication = medication.copyWith(id: id);
      _medications.insert(0, newMedication);

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add medication: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMedication(Medication medication) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'medications',
        medication.toMap(),
        where: 'id = ?',
        whereArgs: [medication.id],
      );

      final index = _medications.indexWhere((m) => m.id == medication.id);
      if (index != -1) {
        _medications[index] = medication;
      }

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update medication: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMedication(int id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete(
        'medications',
        where: 'id = ?',
        whereArgs: [id],
      );

      _medications.removeWhere((m) => m.id == id);

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete medication: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleMedicationStatus(int id) async {
    try {
      final index = _medications.indexWhere((m) => m.id == id);
      if (index == -1) return false;

      final medication = _medications[index];
      final updated = medication.copyWith(isActive: !medication.isActive);

      return await updateMedication(updated);
    } catch (e) {
      _error = 'Failed to toggle medication status: $e';
      notifyListeners();
      return false;
    }
  }
}
