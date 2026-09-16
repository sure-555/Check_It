import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider with ChangeNotifier {
  static const String _boxName = 'settings';
  
  late Box _box;

  SettingsProvider() {
    _box = Hive.box(_boxName);
  }

  // Profile
  String get profileName => _box.get('profile_name', defaultValue: 'Inspector Rajesh Kumar');
  String get profileId => _box.get('profile_id', defaultValue: 'LM-2024-IN-78432');
  String get profileDepartment => _box.get('profile_department', defaultValue: 'Ministry of Consumer Affairs');
  String get profileBadge => _box.get('profile_badge', defaultValue: '');
  String get profileEmail => _box.get('profile_email', defaultValue: 'rajesh.kumar@gov.in');
  String get profilePhone => _box.get('profile_phone', defaultValue: '9876543210');

  String? get profileImagePath => _box.get('profile_image_path') as String?;
  void setProfileImagePath(String? path) {
    if (path == null) {
      _box.delete('profile_image_path');
    } else {
      _box.put('profile_image_path', path);
    }
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String id,
    required String department,
    required String badge,
    required String email,
    required String phone,
  }) {
    _box.put('profile_name', name);
    _box.put('profile_id', id);
    _box.put('profile_department', department);
    _box.put('profile_badge', badge);
    _box.put('profile_email', email);
    _box.put('profile_phone', phone);
    notifyListeners();
  }

  // Offline Mode
  bool get isOfflineMode => _box.get('settings_offline_mode', defaultValue: false);
  void setOfflineMode(bool value) {
    _box.put('settings_offline_mode', value);
    notifyListeners();
  }

  // Notifications
  bool get scanAlerts => _box.get('settings_notifications_scan', defaultValue: true);
  void setScanAlerts(bool value) {
    _box.put('settings_notifications_scan', value);
    notifyListeners();
  }

  bool get criticalAlerts => _box.get('settings_notifications_critical', defaultValue: true);
  void setCriticalAlerts(bool value) {
    _box.put('settings_notifications_critical', value);
    notifyListeners();
  }

  bool get reportAlerts => _box.get('settings_notifications_report', defaultValue: true);
  void setReportAlerts(bool value) {
    _box.put('settings_notifications_report', value);
    notifyListeners();
  }

  bool get dailySummary => _box.get('settings_notifications_daily', defaultValue: false);
  void setDailySummary(bool value) {
    _box.put('settings_notifications_daily', value);
    notifyListeners();
  }

  bool get soundEffects => _box.get('settings_notifications_sound', defaultValue: true);
  void setSoundEffects(bool value) {
    _box.put('settings_notifications_sound', value);
    notifyListeners();
  }

  // Language
  String get language => _box.get('settings_language', defaultValue: 'English');
  
  Locale get locale {
    switch (language) {
      case 'हिन्दी':
        return const Locale('hi');
      case 'தமிழ்':
        return const Locale('ta');
      case 'English':
      default:
        return const Locale('en');
    }
  }

  void setLanguage(String lang) {
    _box.put('settings_language', lang);
    notifyListeners();
  }
}
