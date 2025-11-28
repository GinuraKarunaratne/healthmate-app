import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/helpers.dart';

class BMIProvider with ChangeNotifier {
  double _height = 170;
  double _weight = 70;
  double _bmi = 0;
  String _category = '';
  String _recommendation = '';

  double get height => _height;
  double get weight => _weight;
  double get bmi => _bmi;
  String get category => _category;
  String get recommendation => _recommendation;

  Future<void> loadSavedValues() async {
    final prefs = await SharedPreferences.getInstance();
    _height = prefs.getDouble('bmi_height') ?? 170;
    _weight = prefs.getDouble('bmi_weight') ?? 70;
    _calculateBMIInternal();
    notifyListeners();
  }

  void _calculateBMIInternal() {
    _bmi = BMIHelper.calculateBMI(_height, _weight);
    _category = BMIHelper.getBMICategory(_bmi);
    _recommendation = BMIHelper.getBMIRecommendation(_bmi);
  }

  Future<void> calculateBMI() async {
    _calculateBMIInternal();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bmi_height', _height);
    await prefs.setDouble('bmi_weight', _weight);

    notifyListeners();
  }

  void setHeight(double height) {
    _height = height;
    notifyListeners();
  }

  void setWeight(double weight) {
    _weight = weight;
    notifyListeners();
  }
}
