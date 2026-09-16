import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CheckIt'**
  String get appTitle;

  /// No description provided for @loginContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get loginContinueAsGuest;

  /// No description provided for @loginInspectorLogin.
  ///
  /// In en, this message translates to:
  /// **'Inspector Login'**
  String get loginInspectorLogin;

  /// No description provided for @loginInspectorId.
  ///
  /// In en, this message translates to:
  /// **'Inspector ID'**
  String get loginInspectorId;

  /// No description provided for @loginPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get loginPin;

  /// No description provided for @loginCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get loginCancel;

  /// No description provided for @loginLoginBtn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLoginBtn;

  /// No description provided for @dashActiveShift.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE SHIFT'**
  String get dashActiveShift;

  /// No description provided for @dashInspectorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Inspector Dashboard'**
  String get dashInspectorDashboard;

  /// No description provided for @dashReadyToBegin.
  ///
  /// In en, this message translates to:
  /// **'Ready to begin compliance checks for Sector 7G. Ensure all equipment is calibrated.'**
  String get dashReadyToBegin;

  /// No description provided for @dashScanPackageLabel.
  ///
  /// In en, this message translates to:
  /// **'SCAN PACKAGE LABEL'**
  String get dashScanPackageLabel;

  /// No description provided for @dashTodaysOverview.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Overview'**
  String get dashTodaysOverview;

  /// No description provided for @dashLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: 10:42 AM'**
  String get dashLastUpdated;

  /// No description provided for @statInspected.
  ///
  /// In en, this message translates to:
  /// **'INSPECTED'**
  String get statInspected;

  /// No description provided for @statCompliant.
  ///
  /// In en, this message translates to:
  /// **'COMPLIANT'**
  String get statCompliant;

  /// No description provided for @statViolations.
  ///
  /// In en, this message translates to:
  /// **'VIOLATIONS'**
  String get statViolations;

  /// No description provided for @statHighRisk.
  ///
  /// In en, this message translates to:
  /// **'HIGH RISK'**
  String get statHighRisk;

  /// No description provided for @dashRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashRecentActivity;

  /// No description provided for @dashViewAllActivity.
  ///
  /// In en, this message translates to:
  /// **'View All Activity'**
  String get dashViewAllActivity;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection History'**
  String get historyTitle;

  /// No description provided for @historyTotalRecords.
  ///
  /// In en, this message translates to:
  /// **'Total: 47 Records'**
  String get historyTotalRecords;

  /// No description provided for @historySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by product name or brand...'**
  String get historySearchHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get filterCritical;

  /// No description provided for @filterMajor.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get filterMajor;

  /// No description provided for @filterMinor.
  ///
  /// In en, this message translates to:
  /// **'Minor'**
  String get filterMinor;

  /// No description provided for @filterCompliant.
  ///
  /// In en, this message translates to:
  /// **'Compliant'**
  String get filterCompliant;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get dateEarlier;

  /// No description provided for @violationsText.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 violation} other{{count} violations}}'**
  String violationsText(int count);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspector Profile'**
  String get profileTitle;

  /// No description provided for @profileSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get profileSyncNow;

  /// No description provided for @profileAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get profileAccountSettings;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileNotificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get profileNotificationPreferences;

  /// No description provided for @profileOfflineStorage.
  ///
  /// In en, this message translates to:
  /// **'Offline Storage & Sync'**
  String get profileOfflineStorage;

  /// No description provided for @profileLegalRuleUpdates.
  ///
  /// In en, this message translates to:
  /// **'Legal & Rule Updates'**
  String get profileLegalRuleUpdates;

  /// No description provided for @profileSecurityBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Security & Biometrics'**
  String get profileSecurityBiometrics;

  /// No description provided for @profileAboutCheckIt.
  ///
  /// In en, this message translates to:
  /// **'About CheckIt'**
  String get profileAboutCheckIt;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmationContent;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get btnLogout;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get editPersonalInformation;

  /// No description provided for @editFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editFullName;

  /// No description provided for @editInspectorId.
  ///
  /// In en, this message translates to:
  /// **'Inspector ID'**
  String get editInspectorId;

  /// No description provided for @editDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get editDepartment;

  /// No description provided for @editBadgeNumber.
  ///
  /// In en, this message translates to:
  /// **'Badge Number'**
  String get editBadgeNumber;

  /// No description provided for @editContactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get editContactInformation;

  /// No description provided for @editEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get editEmailAddress;

  /// No description provided for @editPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editPhoneNumber;

  /// No description provided for @editSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editSaveChanges;

  /// No description provided for @editChangeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get editChangeAvatar;

  /// No description provided for @notifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notifTitle;

  /// No description provided for @notifAlertsAndNotifications.
  ///
  /// In en, this message translates to:
  /// **'Alerts & Notifications'**
  String get notifAlertsAndNotifications;

  /// No description provided for @notifScanAlerts.
  ///
  /// In en, this message translates to:
  /// **'Scan Alerts'**
  String get notifScanAlerts;

  /// No description provided for @notifScanAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when a product fails scan'**
  String get notifScanAlertsDesc;

  /// No description provided for @notifCriticalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Critical Violation Alerts'**
  String get notifCriticalAlerts;

  /// No description provided for @notifCriticalAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Immediate alerts for severe non-compliance'**
  String get notifCriticalAlertsDesc;

  /// No description provided for @notifReportAlerts.
  ///
  /// In en, this message translates to:
  /// **'Report Alerts'**
  String get notifReportAlerts;

  /// No description provided for @notifReportAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications when PDF reports are ready'**
  String get notifReportAlertsDesc;

  /// No description provided for @notifDailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get notifDailySummary;

  /// No description provided for @notifDailySummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Get a daily summary of all inspections'**
  String get notifDailySummaryDesc;

  /// No description provided for @notifAppSounds.
  ///
  /// In en, this message translates to:
  /// **'App Sounds'**
  String get notifAppSounds;

  /// No description provided for @notifSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get notifSoundEffects;

  /// No description provided for @notifSoundEffectsDesc.
  ///
  /// In en, this message translates to:
  /// **'Play sounds for successful/failed scans'**
  String get notifSoundEffectsDesc;

  /// No description provided for @notifVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get notifVibration;

  /// No description provided for @notifVibrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on scan completion'**
  String get notifVibrationDesc;

  /// No description provided for @ruleUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal & Rule Updates'**
  String get ruleUpdatesTitle;

  /// No description provided for @ruleCurrentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get ruleCurrentVersion;

  /// No description provided for @ruleFssaiVersion.
  ///
  /// In en, this message translates to:
  /// **'FSSAI Guidelines v2024.1'**
  String get ruleFssaiVersion;

  /// No description provided for @ruleLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: Oct 12, 2026'**
  String get ruleLastUpdated;

  /// No description provided for @ruleRecentChanges.
  ///
  /// In en, this message translates to:
  /// **'Recent Changes'**
  String get ruleRecentChanges;

  /// No description provided for @ruleChangeAllergen.
  ///
  /// In en, this message translates to:
  /// **'New Allergen Declaration Rules'**
  String get ruleChangeAllergen;

  /// No description provided for @ruleChangeAllergenDesc.
  ///
  /// In en, this message translates to:
  /// **'Updated requirements for declaring trace allergens on primary packaging.'**
  String get ruleChangeAllergenDesc;

  /// No description provided for @ruleChangeServing.
  ///
  /// In en, this message translates to:
  /// **'Standardized Serving Sizes'**
  String get ruleChangeServing;

  /// No description provided for @ruleChangeServingDesc.
  ///
  /// In en, this message translates to:
  /// **'New standardized metrics for nutritional information per 100g/100ml.'**
  String get ruleChangeServingDesc;

  /// No description provided for @ruleChangeQr.
  ///
  /// In en, this message translates to:
  /// **'Mandatory QR Code on Packaging'**
  String get ruleChangeQr;

  /// No description provided for @ruleChangeQrDesc.
  ///
  /// In en, this message translates to:
  /// **'Implementation timeline for mandatory digital traceability QR codes.'**
  String get ruleChangeQrDesc;

  /// No description provided for @ruleCheckForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get ruleCheckForUpdates;

  /// No description provided for @scanInstructionFront.
  ///
  /// In en, this message translates to:
  /// **'Scan the FRONT label'**
  String get scanInstructionFront;

  /// No description provided for @scanInstructionLeft.
  ///
  /// In en, this message translates to:
  /// **'Scan the LEFT side'**
  String get scanInstructionLeft;

  /// No description provided for @scanInstructionRight.
  ///
  /// In en, this message translates to:
  /// **'Scan the RIGHT side'**
  String get scanInstructionRight;

  /// No description provided for @scanInstructionAlign.
  ///
  /// In en, this message translates to:
  /// **'Align the label inside the frame'**
  String get scanInstructionAlign;

  /// No description provided for @scanStatusSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get scanStatusSearching;

  /// No description provided for @scanStatusLabelDetected.
  ///
  /// In en, this message translates to:
  /// **'Label detected'**
  String get scanStatusLabelDetected;

  /// No description provided for @scanStatusHoldSteady.
  ///
  /// In en, this message translates to:
  /// **'Hold steady'**
  String get scanStatusHoldSteady;

  /// No description provided for @scanStatusCaptured.
  ///
  /// In en, this message translates to:
  /// **'Captured!'**
  String get scanStatusCaptured;

  /// No description provided for @scanBtnRetake.
  ///
  /// In en, this message translates to:
  /// **'RETAKE'**
  String get scanBtnRetake;

  /// No description provided for @scanBtnContinue.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get scanBtnContinue;

  /// No description provided for @scanSideFront.
  ///
  /// In en, this message translates to:
  /// **'FRONT'**
  String get scanSideFront;

  /// No description provided for @scanSideLeft.
  ///
  /// In en, this message translates to:
  /// **'LEFT'**
  String get scanSideLeft;

  /// No description provided for @scanSideRight.
  ///
  /// In en, this message translates to:
  /// **'RIGHT'**
  String get scanSideRight;

  /// No description provided for @scanBtnAnalyze.
  ///
  /// In en, this message translates to:
  /// **'ANALYZE'**
  String get scanBtnAnalyze;

  /// No description provided for @scanStatusCapturedTitle.
  ///
  /// In en, this message translates to:
  /// **'✓ {side} CAPTURED'**
  String scanStatusCapturedTitle(String side);

  /// No description provided for @scanProgressText.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} COMPLETE'**
  String scanProgressText(int completed, int total);

  /// No description provided for @analysisReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Analysis Report'**
  String get analysisReportTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @msgProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile successfully updated'**
  String get msgProfileUpdated;

  /// No description provided for @editEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get editEmail;

  /// No description provided for @errEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get errEmailRequired;

  /// No description provided for @errEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get errEmailInvalid;

  /// No description provided for @editPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editPhone;

  /// No description provided for @errPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get errPhoneRequired;

  /// No description provided for @errPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits'**
  String get errPhoneInvalid;

  /// No description provided for @btnSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get btnSaveChanges;

  /// No description provided for @errNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get errNameRequired;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettingsTitle;

  /// No description provided for @ruleLmpcTitle.
  ///
  /// In en, this message translates to:
  /// **'LMPC Act Updates'**
  String get ruleLmpcTitle;

  /// No description provided for @ruleLmpcSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New packaging guidelines for electronics'**
  String get ruleLmpcSubtitle;

  /// No description provided for @ruleFssaiTitle.
  ///
  /// In en, this message translates to:
  /// **'FSSAI New Regulations'**
  String get ruleFssaiTitle;

  /// No description provided for @ruleFssaiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Updated allergen declaration rules'**
  String get ruleFssaiSubtitle;

  /// No description provided for @ruleDigitalEvidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Evidence Protocol'**
  String get ruleDigitalEvidenceTitle;

  /// No description provided for @ruleDigitalEvidenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Acceptable formats for digital images'**
  String get ruleDigitalEvidenceSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
