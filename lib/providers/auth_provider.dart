import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum UserRole { guest, inspector }

class AuthProvider extends ChangeNotifier {
  UserRole _role = UserRole.guest;
  bool _isAuthenticated = false;
  String? _inspectorId;
  String? _inspectorName;

  UserRole get role => _role;
  bool get isAuthenticated => _isAuthenticated;
  String? get inspectorId => _inspectorId;
  String? get inspectorName => _inspectorName;

  bool get isInspector => _role == UserRole.inspector && _isAuthenticated;

  AuthProvider() {
    _loadState();
  }

  void _loadState() {
    final box = Hive.box('settings');
    final isLoggedIn = box.get('isLoggedIn', defaultValue: false) as bool;
    final storedInspectorId = box.get('inspectorId') as String?;

    if (isLoggedIn && storedInspectorId != null) {
      _role = UserRole.inspector;
      _isAuthenticated = true;
      _inspectorId = storedInspectorId;
      _inspectorName = 'Inspector'; // Could store name too
    }
  }

  void loginAsGuest() {
    _role = UserRole.guest;
    _isAuthenticated = true;
    _inspectorId = null;
    _inspectorName = null;
    notifyListeners();
  }

  Future<bool> loginAsInspector(String id, String pin) async {
    // Hardcoded credentials verification
    bool isValid = false;
    if (id == 'INS-2026-001' && pin == 'demo123') {
      isValid = true;
    } else if (id == 'INS-2026-002' && pin == 'demo456') {
      isValid = true;
    }

    if (isValid) {
      _role = UserRole.inspector;
      _isAuthenticated = true;
      _inspectorId = id;
      _inspectorName = 'Inspector $id';

      // Save to Hive
      final box = Hive.box('settings');
      await box.put('isLoggedIn', true);
      await box.put('inspectorId', id);

      notifyListeners();
      return true;
    }
    return false;
  }

  bool validatePassword(String pin) {
    if (_inspectorId == 'INS-2026-001' && pin == 'demo123') return true;
    if (_inspectorId == 'INS-2026-002' && pin == 'demo456') return true;
    return false;
  }

  Future<void> logout() async {
    _role = UserRole.guest;
    _isAuthenticated = false;
    _inspectorId = null;
    _inspectorName = null;

    // Clear from Hive
    final box = Hive.box('settings');
    await box.delete('isLoggedIn');
    await box.delete('inspectorId');

    notifyListeners();
  }
}
