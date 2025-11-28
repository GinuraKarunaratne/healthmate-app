import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import '../core/helpers.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _rememberMe = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get rememberMe => _rememberMe;

  // Initialize and check for remembered user
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberedEmail = prefs.getString('remembered_email');

      if (rememberedEmail != null) {
        _rememberMe = true;
        // Auto-login if remembered
        final user = await DatabaseHelper.instance.getUserByEmail(rememberedEmail);
        if (user != null) {
          _currentUser = user;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    }
  }

  // Set remember me preference
  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  // Login with enhanced features
  Future<bool> login(String email, String password, {bool rememberMe = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Validate email format first
      if (!_isValidEmail(email)) {
        _error = 'Please enter a valid email address';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final user = await DatabaseHelper.instance.getUserByEmail(email);

      if (user == null) {
        _error = 'No account found with this email';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!PasswordHelper.verifyPassword(password, user.passwordHash)) {
        _error = 'Incorrect password. Please try again';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      _rememberMe = rememberMe;

      // Save remember me preference
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('remembered_email', email);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('remembered_email');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Login failed. Please try again';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Signup with enhanced validation
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Validate inputs
      if (name.trim().isEmpty) {
        _error = 'Please enter your name';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!_isValidEmail(email)) {
        _error = 'Please enter a valid email address';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _error = 'Password must be at least 6 characters';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if email already exists
      final existingUser = await DatabaseHelper.instance.getUserByEmail(email);

      if (existingUser != null) {
        _error = 'An account with this email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final passwordHash = PasswordHelper.hashPassword(password);
      final newUser = User(
        name: name.trim(),
        email: email.trim().toLowerCase(),
        passwordHash: passwordHash,
      );

      _currentUser = await DatabaseHelper.instance.createUser(newUser);

      // Auto-save for remember me
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('remembered_email', email.trim().toLowerCase());
      _rememberMe = true;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Signup failed. Please try again';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Check if email exists (for validation)
  Future<bool> checkEmailExists(String email) async {
    try {
      final user = await DatabaseHelper.instance.getUserByEmail(email.trim().toLowerCase());
      return user != null;
    } catch (e) {
      return false;
    }
  }

  // Password reset request (simulated for now)
  Future<bool> requestPasswordReset(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!_isValidEmail(email)) {
        _error = 'Please enter a valid email address';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final user = await DatabaseHelper.instance.getUserByEmail(email);

      if (user == null) {
        _error = 'No account found with this email';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // In a real app, you would send a password reset email here
      // For now, we'll just simulate success
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to send reset email. Please try again';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;

    if (!_rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('remembered_email');
    }

    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Email validation helper
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }

  // Calculate password strength (0-4)
  int getPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    // Normalize to 0-4 scale
    if (strength >= 6) return 4;
    if (strength >= 4) return 3;
    if (strength >= 3) return 2;
    if (strength >= 2) return 1;
    return 0;
  }

  // Get password strength label
  String getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
        return 'Too Weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Too Weak';
    }
  }
}
