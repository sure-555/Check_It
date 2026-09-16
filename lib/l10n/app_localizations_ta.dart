// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'CheckIt';

  @override
  String get loginContinueAsGuest => 'விருந்தினராக தொடரவும்';

  @override
  String get loginInspectorLogin => 'ஆய்வாளர் உள்நுழைவு';

  @override
  String get loginInspectorId => 'ஆய்வாளர் ஐடி';

  @override
  String get loginPin => 'பின்';

  @override
  String get loginCancel => 'ரத்துசெய்';

  @override
  String get loginLoginBtn => 'உள்நுழை';

  @override
  String get dashActiveShift => 'செயலில் உள்ள ஷிப்ட்';

  @override
  String get dashInspectorDashboard => 'முகப்பு';

  @override
  String get dashReadyToBegin =>
      'பிரிவு 7G க்கான இணக்க சோதனைகளைத் தொடங்க தயார். அனைத்து உபகரணங்களும் அளவீடு செய்யப்பட்டுள்ளதா என்பதை உறுதிப்படுத்தவும்.';

  @override
  String get dashScanPackageLabel => 'தொகுப்பு லேபிளை ஸ்கேன் செய்';

  @override
  String get dashTodaysOverview => 'இன்றைய மேலோட்டம்';

  @override
  String get dashLastUpdated => 'கடைசியாக புதுப்பிக்கப்பட்டது: காலை 10:42';

  @override
  String get statInspected => 'ஆய்வு செய்யப்பட்டது';

  @override
  String get statCompliant => 'இணக்கமானது';

  @override
  String get statViolations => 'மீறல்கள்';

  @override
  String get statHighRisk => 'அதிக ஆபத்து';

  @override
  String get dashRecentActivity => 'சமீபத்திய செயல்பாடு';

  @override
  String get dashViewAllActivity => 'அனைத்து செயல்பாடுகளையும் காண்க';

  @override
  String get historyTitle => 'ஆய்வு வரலாறு';

  @override
  String get historyTotalRecords => 'மொத்தம்: 47 பதிவுகள்';

  @override
  String get historySearchHint =>
      'தயாரிப்பு பெயர் அல்லது பிராண்ட் மூலம் தேடவும்...';

  @override
  String get filterAll => 'அனைத்தும்';

  @override
  String get filterCritical => 'மிக முக்கியமானது';

  @override
  String get filterMajor => 'பெரியது';

  @override
  String get filterMinor => 'சிறியது';

  @override
  String get filterCompliant => 'இணக்கமானது';

  @override
  String get dateToday => 'இன்று';

  @override
  String get dateYesterday => 'நேற்று';

  @override
  String get dateEarlier => 'முன்னதாக';

  @override
  String violationsText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மீறல்கள்',
      one: '1 மீறல்',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'சுயவிவரம்';

  @override
  String get profileSyncNow => 'இப்போது ஒத்திசை';

  @override
  String get profileAccountSettings => 'கணக்கு அமைப்புகள்';

  @override
  String get profileLanguage => 'மொழி (Language)';

  @override
  String get profileNotificationPreferences => 'அறிவிப்பு விருப்பங்கள்';

  @override
  String get profileOfflineStorage => 'ஆஃப்லைன் சேமிப்பு & ஒத்திசைவு';

  @override
  String get profileLegalRuleUpdates => 'சட்ட மற்றும் விதி புதுப்பிப்புகள்';

  @override
  String get profileSecurityBiometrics => 'பாதுகாப்பு மற்றும் பயோமெட்ரிக்ஸ்';

  @override
  String get profileAboutCheckIt => 'CheckIt பற்றி';

  @override
  String get profileLogout => 'வெளியேறு';

  @override
  String get logoutConfirmationTitle => 'வெளியேறு';

  @override
  String get logoutConfirmationContent =>
      'நீங்கள் நிச்சயமாக வெளியேற விரும்புகிறீர்களா?';

  @override
  String get btnCancel => 'ரத்துசெய்';

  @override
  String get btnLogout => 'வெளியேறு';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get editProfileTitle => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get editPersonalInformation => 'தனிப்பட்ட தகவல்';

  @override
  String get editFullName => 'முழு பெயர்';

  @override
  String get editInspectorId => 'ஆய்வாளர் ஐடி';

  @override
  String get editDepartment => 'துறை';

  @override
  String get editBadgeNumber => 'பேட்ஜ் எண்';

  @override
  String get editContactInformation => 'தொடர்பு தகவல்';

  @override
  String get editEmailAddress => 'மின்னஞ்சல் முகவரி';

  @override
  String get editPhoneNumber => 'தொலைபேசி எண்';

  @override
  String get editSaveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get editChangeAvatar => 'அவதாரத்தை மாற்று';

  @override
  String get notifTitle => 'அறிவிப்பு அமைப்புகள்';

  @override
  String get notifAlertsAndNotifications =>
      'எச்சரிக்கைகள் மற்றும் அறிவிப்புகள்';

  @override
  String get notifScanAlerts => 'ஸ்கேன் எச்சரிக்கைகள்';

  @override
  String get notifScanAlertsDesc =>
      'தயாரிப்பு ஸ்கேன் தோல்வியடையும் போது அறிவிப்பைப் பெறுக';

  @override
  String get notifCriticalAlerts => 'முக்கிய மீறல் எச்சரிக்கைகள்';

  @override
  String get notifCriticalAlertsDesc =>
      'கடுமையான இணக்கமின்மைக்கான உடனடி எச்சரிக்கைகள்';

  @override
  String get notifReportAlerts => 'அறிக்கை எச்சரிக்கைகள்';

  @override
  String get notifReportAlertsDesc =>
      'PDF அறிக்கைகள் தயாராக இருக்கும்போது அறிவிப்புகள்';

  @override
  String get notifDailySummary => 'தினசரி சுருக்கம்';

  @override
  String get notifDailySummaryDesc =>
      'அனைத்து ஆய்வுகளின் தினசரி சுருக்கத்தைப் பெறுக';

  @override
  String get notifAppSounds => 'பயன்பாட்டு ஒலிகள்';

  @override
  String get notifSoundEffects => 'ஒலி விளைவுகள்';

  @override
  String get notifSoundEffectsDesc =>
      'வெற்றிகரமான/தோல்வியுற்ற ஸ்கேன்களுக்கு ஒலிகளை இயக்கவும்';

  @override
  String get notifVibration => 'அதிர்வு';

  @override
  String get notifVibrationDesc => 'ஸ்கேன் முடிந்ததும் அதிர்வுறும்';

  @override
  String get ruleUpdatesTitle => 'சட்ட மற்றும் விதி புதுப்பிப்புகள்';

  @override
  String get ruleCurrentVersion => 'தற்போதைய பதிப்பு';

  @override
  String get ruleFssaiVersion => 'FSSAI வழிகாட்டுதல்கள் v2024.1';

  @override
  String get ruleLastUpdated => 'கடைசியாக புதுப்பிக்கப்பட்டது: அக் 12, 2026';

  @override
  String get ruleRecentChanges => 'சமீபத்திய மாற்றங்கள்';

  @override
  String get ruleChangeAllergen => 'புதிய ஒவ்வாமை அறிவிப்பு விதிகள்';

  @override
  String get ruleChangeAllergenDesc =>
      'முதன்மை பேக்கேஜிங்கில் சுவடு ஒவ்வாமைகளை அறிவிப்பதற்கான புதுப்பிக்கப்பட்ட தேவைகள்.';

  @override
  String get ruleChangeServing => 'தரப்படுத்தப்பட்ட சேவை அளவுகள்';

  @override
  String get ruleChangeServingDesc =>
      'ஒரு 100g/100ml ஊட்டச்சத்து தகவலுக்கான புதிய தரப்படுத்தப்பட்ட அளவீடுகள்.';

  @override
  String get ruleChangeQr => 'பேக்கேஜிங்கில் கட்டாய QR குறியீடு';

  @override
  String get ruleChangeQrDesc =>
      'கட்டாய டிஜிட்டல் கண்டறியும் தன்மை QR குறியீடுகளுக்கான செயலாக்க காலவரிசை.';

  @override
  String get ruleCheckForUpdates => 'புதுப்பிப்புகளைச் சரிபார்க்கவும்';

  @override
  String get scanInstructionFront => 'முன்பக்க லேபிளை ஸ்கேன் செய்';

  @override
  String get scanInstructionLeft => 'இடது பக்கத்தை ஸ்கேன் செய்';

  @override
  String get scanInstructionRight => 'வலது பக்கத்தை ஸ்கேன் செய்';

  @override
  String get scanInstructionAlign => 'லேபிளை சட்டகத்திற்குள் சீரமைக்கவும';

  @override
  String get scanStatusSearching => 'தேடப்படுகிறது...';

  @override
  String get scanStatusLabelDetected => 'லேபிள் கண்டறியப்பட்டது';

  @override
  String get scanStatusHoldSteady => 'நிலையாக வைத்திருக்கவும்';

  @override
  String get scanStatusCaptured => 'படம் பிடிக்கப்பட்டது!';

  @override
  String get scanBtnRetake => 'மீண்டும் எடு';

  @override
  String get scanBtnContinue => 'தொடரவும்';

  @override
  String get scanSideFront => 'முன்பக்கம்';

  @override
  String get scanSideLeft => 'இடது';

  @override
  String get scanSideRight => 'வலது';

  @override
  String get scanBtnAnalyze => 'பகுப்பாய்வு செய்';

  @override
  String scanStatusCapturedTitle(String side) {
    return '✓ $side படம் பிடிக்கப்பட்டது';
  }

  @override
  String scanProgressText(int completed, int total) {
    return '$completed/$total முடிந்தது';
  }

  @override
  String get analysisReportTitle => 'பகுப்பாய்வு அறிக்கை';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navHistory => 'வரலாறு';

  @override
  String get navReports => 'அறிக்கைகள்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get navScan => 'ஸ்கேன்';

  @override
  String get msgProfileUpdated => 'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String get editEmail => 'மின்னஞ்சல் முகவரி';

  @override
  String get errEmailRequired => 'மின்னஞ்சல் தேவை';

  @override
  String get errEmailInvalid => 'சரியான மின்னஞ்சலை உள்ளிடவும்';

  @override
  String get editPhone => 'தொலைபேசி எண்';

  @override
  String get errPhoneRequired => 'தொலைபேசி எண் தேவை';

  @override
  String get errPhoneInvalid => 'தொலைபேசி எண் 10 இலக்கங்களாக இருக்க வேண்டும்';

  @override
  String get btnSaveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get errNameRequired => 'பெயர் தேவை';

  @override
  String get notificationSettingsTitle => 'அறிவிப்பு அமைப்புகள்';

  @override
  String get ruleLmpcTitle => 'LMPC சட்ட புதுப்பிப்புகள்';

  @override
  String get ruleLmpcSubtitle =>
      'மின்னணு சாதனங்களுக்கான புதிய பேக்கேஜிங் வழிகாட்டுதல்கள்';

  @override
  String get ruleFssaiTitle => 'FSSAI புதிய விதிமுறைகள்';

  @override
  String get ruleFssaiSubtitle => 'புதுப்பிக்கப்பட்ட ஒவ்வாமை அறிவிப்பு விதிகள்';

  @override
  String get ruleDigitalEvidenceTitle => 'டிஜிட்டல் சான்றுகள் நெறிமுறை';

  @override
  String get ruleDigitalEvidenceSubtitle =>
      'டிஜிட்டல் படங்களுக்கான ஏற்கத்தக்க வடிவங்கள்';
}
