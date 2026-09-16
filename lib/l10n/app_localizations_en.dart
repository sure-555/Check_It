// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CheckIt';

  @override
  String get loginContinueAsGuest => 'Continue as Guest';

  @override
  String get loginInspectorLogin => 'Inspector Login';

  @override
  String get loginInspectorId => 'Inspector ID';

  @override
  String get loginPin => 'PIN';

  @override
  String get loginCancel => 'Cancel';

  @override
  String get loginLoginBtn => 'Login';

  @override
  String get dashActiveShift => 'ACTIVE SHIFT';

  @override
  String get dashInspectorDashboard => 'Inspector Dashboard';

  @override
  String get dashReadyToBegin =>
      'Ready to begin compliance checks for Sector 7G. Ensure all equipment is calibrated.';

  @override
  String get dashScanPackageLabel => 'SCAN PACKAGE LABEL';

  @override
  String get dashTodaysOverview => 'Today\'s Overview';

  @override
  String get dashLastUpdated => 'Last updated: 10:42 AM';

  @override
  String get statInspected => 'INSPECTED';

  @override
  String get statCompliant => 'COMPLIANT';

  @override
  String get statViolations => 'VIOLATIONS';

  @override
  String get statHighRisk => 'HIGH RISK';

  @override
  String get dashRecentActivity => 'Recent Activity';

  @override
  String get dashViewAllActivity => 'View All Activity';

  @override
  String get historyTitle => 'Inspection History';

  @override
  String get historyTotalRecords => 'Total: 47 Records';

  @override
  String get historySearchHint => 'Search by product name or brand...';

  @override
  String get filterAll => 'All';

  @override
  String get filterCritical => 'Critical';

  @override
  String get filterMajor => 'Major';

  @override
  String get filterMinor => 'Minor';

  @override
  String get filterCompliant => 'Compliant';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get dateEarlier => 'Earlier';

  @override
  String violationsText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count violations',
      one: '1 violation',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'Inspector Profile';

  @override
  String get profileSyncNow => 'Sync Now';

  @override
  String get profileAccountSettings => 'Account Settings';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileNotificationPreferences => 'Notification Preferences';

  @override
  String get profileOfflineStorage => 'Offline Storage & Sync';

  @override
  String get profileLegalRuleUpdates => 'Legal & Rule Updates';

  @override
  String get profileSecurityBiometrics => 'Security & Biometrics';

  @override
  String get profileAboutCheckIt => 'About CheckIt';

  @override
  String get profileLogout => 'Logout';

  @override
  String get logoutConfirmationTitle => 'Logout';

  @override
  String get logoutConfirmationContent => 'Are you sure you want to log out?';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnLogout => 'Logout';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editPersonalInformation => 'Personal Information';

  @override
  String get editFullName => 'Full Name';

  @override
  String get editInspectorId => 'Inspector ID';

  @override
  String get editDepartment => 'Department';

  @override
  String get editBadgeNumber => 'Badge Number';

  @override
  String get editContactInformation => 'Contact Information';

  @override
  String get editEmailAddress => 'Email Address';

  @override
  String get editPhoneNumber => 'Phone Number';

  @override
  String get editSaveChanges => 'Save Changes';

  @override
  String get editChangeAvatar => 'Change Avatar';

  @override
  String get notifTitle => 'Notification Settings';

  @override
  String get notifAlertsAndNotifications => 'Alerts & Notifications';

  @override
  String get notifScanAlerts => 'Scan Alerts';

  @override
  String get notifScanAlertsDesc => 'Get notified when a product fails scan';

  @override
  String get notifCriticalAlerts => 'Critical Violation Alerts';

  @override
  String get notifCriticalAlertsDesc =>
      'Immediate alerts for severe non-compliance';

  @override
  String get notifReportAlerts => 'Report Alerts';

  @override
  String get notifReportAlertsDesc =>
      'Notifications when PDF reports are ready';

  @override
  String get notifDailySummary => 'Daily Summary';

  @override
  String get notifDailySummaryDesc => 'Get a daily summary of all inspections';

  @override
  String get notifAppSounds => 'App Sounds';

  @override
  String get notifSoundEffects => 'Sound Effects';

  @override
  String get notifSoundEffectsDesc => 'Play sounds for successful/failed scans';

  @override
  String get notifVibration => 'Vibration';

  @override
  String get notifVibrationDesc => 'Vibrate on scan completion';

  @override
  String get ruleUpdatesTitle => 'Legal & Rule Updates';

  @override
  String get ruleCurrentVersion => 'Current Version';

  @override
  String get ruleFssaiVersion => 'FSSAI Guidelines v2024.1';

  @override
  String get ruleLastUpdated => 'Last updated: Oct 12, 2026';

  @override
  String get ruleRecentChanges => 'Recent Changes';

  @override
  String get ruleChangeAllergen => 'New Allergen Declaration Rules';

  @override
  String get ruleChangeAllergenDesc =>
      'Updated requirements for declaring trace allergens on primary packaging.';

  @override
  String get ruleChangeServing => 'Standardized Serving Sizes';

  @override
  String get ruleChangeServingDesc =>
      'New standardized metrics for nutritional information per 100g/100ml.';

  @override
  String get ruleChangeQr => 'Mandatory QR Code on Packaging';

  @override
  String get ruleChangeQrDesc =>
      'Implementation timeline for mandatory digital traceability QR codes.';

  @override
  String get ruleCheckForUpdates => 'Check for Updates';

  @override
  String get scanInstructionFront => 'Scan the FRONT label';

  @override
  String get scanInstructionLeft => 'Scan the LEFT side';

  @override
  String get scanInstructionRight => 'Scan the RIGHT side';

  @override
  String get scanInstructionAlign => 'Align the label inside the frame';

  @override
  String get scanStatusSearching => 'Searching...';

  @override
  String get scanStatusLabelDetected => 'Label detected';

  @override
  String get scanStatusHoldSteady => 'Hold steady';

  @override
  String get scanStatusCaptured => 'Captured!';

  @override
  String get scanBtnRetake => 'RETAKE';

  @override
  String get scanBtnContinue => 'CONTINUE';

  @override
  String get scanSideFront => 'FRONT';

  @override
  String get scanSideLeft => 'LEFT';

  @override
  String get scanSideRight => 'RIGHT';

  @override
  String get scanBtnAnalyze => 'ANALYZE';

  @override
  String scanStatusCapturedTitle(String side) {
    return '✓ $side CAPTURED';
  }

  @override
  String scanProgressText(int completed, int total) {
    return '$completed/$total COMPLETE';
  }

  @override
  String get analysisReportTitle => 'Analysis Report';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navReports => 'Reports';

  @override
  String get navProfile => 'Profile';

  @override
  String get navScan => 'Scan';

  @override
  String get msgProfileUpdated => 'Profile successfully updated';

  @override
  String get editEmail => 'Email Address';

  @override
  String get errEmailRequired => 'Email is required';

  @override
  String get errEmailInvalid => 'Enter a valid email';

  @override
  String get editPhone => 'Phone Number';

  @override
  String get errPhoneRequired => 'Phone number is required';

  @override
  String get errPhoneInvalid => 'Phone number must be 10 digits';

  @override
  String get btnSaveChanges => 'Save Changes';

  @override
  String get errNameRequired => 'Name is required';

  @override
  String get notificationSettingsTitle => 'Notification Settings';

  @override
  String get ruleLmpcTitle => 'LMPC Act Updates';

  @override
  String get ruleLmpcSubtitle => 'New packaging guidelines for electronics';

  @override
  String get ruleFssaiTitle => 'FSSAI New Regulations';

  @override
  String get ruleFssaiSubtitle => 'Updated allergen declaration rules';

  @override
  String get ruleDigitalEvidenceTitle => 'Digital Evidence Protocol';

  @override
  String get ruleDigitalEvidenceSubtitle =>
      'Acceptable formats for digital images';
}
