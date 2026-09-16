// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'CheckIt';

  @override
  String get loginContinueAsGuest => 'अतिथि के रूप में जारी रखें';

  @override
  String get loginInspectorLogin => 'निरीक्षक लॉगिन';

  @override
  String get loginInspectorId => 'निरीक्षक आईडी';

  @override
  String get loginPin => 'पिन';

  @override
  String get loginCancel => 'रद्द करें';

  @override
  String get loginLoginBtn => 'लॉगिन';

  @override
  String get dashActiveShift => 'सक्रिय शिफ्ट';

  @override
  String get dashInspectorDashboard => 'निरीक्षक डैशबोर्ड';

  @override
  String get dashReadyToBegin =>
      'सेक्टर 7G के लिए अनुपालन जांच शुरू करने के लिए तैयार। सुनिश्चित करें कि सभी उपकरण कैलिब्रेटेड हैं।';

  @override
  String get dashScanPackageLabel => 'पैकेज लेबल स्कैन करें';

  @override
  String get dashTodaysOverview => 'आज का अवलोकन';

  @override
  String get dashLastUpdated => 'अंतिम अद्यतन: सुबह 10:42 बजे';

  @override
  String get statInspected => 'निरीक्षण किया गया';

  @override
  String get statCompliant => 'अनुपालन';

  @override
  String get statViolations => 'उल्लंघन';

  @override
  String get statHighRisk => 'उच्च जोखिम';

  @override
  String get dashRecentActivity => 'हाल की गतिविधि';

  @override
  String get dashViewAllActivity => 'सभी गतिविधि देखें';

  @override
  String get historyTitle => 'निरीक्षण इतिहास';

  @override
  String get historyTotalRecords => 'कुल: 47 रिकॉर्ड';

  @override
  String get historySearchHint => 'उत्पाद का नाम या ब्रांड से खोजें...';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterCritical => 'महत्वपूर्ण';

  @override
  String get filterMajor => 'प्रमुख';

  @override
  String get filterMinor => 'मामूली';

  @override
  String get filterCompliant => 'अनुपालन';

  @override
  String get dateToday => 'आज';

  @override
  String get dateYesterday => 'कल';

  @override
  String get dateEarlier => 'पहले';

  @override
  String violationsText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उल्लंघन',
      one: '1 उल्लंघन',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'निरीक्षक प्रोफ़ाइल';

  @override
  String get profileSyncNow => 'अभी सिंक करें';

  @override
  String get profileAccountSettings => 'खाता सेटिंग्स';

  @override
  String get profileLanguage => 'भाषा (Language)';

  @override
  String get profileNotificationPreferences => 'अधिसूचना प्राथमिकताएँ';

  @override
  String get profileOfflineStorage => 'ऑफ़लाइन स्टोरेज और सिंक';

  @override
  String get profileLegalRuleUpdates => 'कानूनी और नियम अपडेट';

  @override
  String get profileSecurityBiometrics => 'सुरक्षा और बायोमेट्रिक्स';

  @override
  String get profileAboutCheckIt => 'CheckIt के बारे में';

  @override
  String get profileLogout => 'लॉगआउट';

  @override
  String get logoutConfirmationTitle => 'लॉगआउट';

  @override
  String get logoutConfirmationContent => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get btnCancel => 'रद्द करें';

  @override
  String get btnLogout => 'लॉगआउट';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get editProfileTitle => 'प्रोफ़ाइल संपादित करें';

  @override
  String get editPersonalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get editFullName => 'पूरा नाम';

  @override
  String get editInspectorId => 'निरीक्षक आईडी';

  @override
  String get editDepartment => 'विभाग';

  @override
  String get editBadgeNumber => 'बैज नंबर';

  @override
  String get editContactInformation => 'संपर्क जानकारी';

  @override
  String get editEmailAddress => 'ईमेल पता';

  @override
  String get editPhoneNumber => 'फ़ोन नंबर';

  @override
  String get editSaveChanges => 'परिवर्तन सहेजें';

  @override
  String get editChangeAvatar => 'अवतार बदलें';

  @override
  String get notifTitle => 'अधिसूचना सेटिंग्स';

  @override
  String get notifAlertsAndNotifications => 'अलर्ट और सूचनाएं';

  @override
  String get notifScanAlerts => 'स्कैन अलर्ट';

  @override
  String get notifScanAlertsDesc =>
      'उत्पाद स्कैन विफल होने पर सूचना प्राप्त करें';

  @override
  String get notifCriticalAlerts => 'महत्वपूर्ण उल्लंघन अलर्ट';

  @override
  String get notifCriticalAlertsDesc => 'गंभीर गैर-अनुपालन के लिए तत्काल अलर्ट';

  @override
  String get notifReportAlerts => 'रिपोर्ट अलर्ट';

  @override
  String get notifReportAlertsDesc => 'पीडीएफ रिपोर्ट तैयार होने पर सूचनाएं';

  @override
  String get notifDailySummary => 'दैनिक सारांश';

  @override
  String get notifDailySummaryDesc =>
      'सभी निरीक्षणों का दैनिक सारांश प्राप्त करें';

  @override
  String get notifAppSounds => 'ऐप ध्वनियां';

  @override
  String get notifSoundEffects => 'ध्वनि प्रभाव';

  @override
  String get notifSoundEffectsDesc => 'सफल/विफल स्कैन के लिए ध्वनियां चलाएं';

  @override
  String get notifVibration => 'कंपन';

  @override
  String get notifVibrationDesc => 'स्कैन पूरा होने पर कंपन करें';

  @override
  String get ruleUpdatesTitle => 'कानूनी और नियम अपडेट';

  @override
  String get ruleCurrentVersion => 'वर्तमान संस्करण';

  @override
  String get ruleFssaiVersion => 'FSSAI दिशानिर्देश v2024.1';

  @override
  String get ruleLastUpdated => 'अंतिम अद्यतन: 12 अक्टूबर, 2026';

  @override
  String get ruleRecentChanges => 'हाल के बदलाव';

  @override
  String get ruleChangeAllergen => 'नए एलर्जेन घोषणा नियम';

  @override
  String get ruleChangeAllergenDesc =>
      'प्राथमिक पैकेजिंग पर ट्रेस एलर्जेंस घोषित करने के लिए अद्यतन आवश्यकताएं।';

  @override
  String get ruleChangeServing => 'मानकीकृत सर्विंग आकार';

  @override
  String get ruleChangeServingDesc =>
      'प्रति 100g/100ml पोषण संबंधी जानकारी के लिए नए मानकीकृत मेट्रिक्स।';

  @override
  String get ruleChangeQr => 'पैकेजिंग पर अनिवार्य क्यूआर कोड';

  @override
  String get ruleChangeQrDesc =>
      'अनिवार्य डिजिटल ट्रैसेबिलिटी क्यूआर कोड के लिए कार्यान्वयन समयरेखा।';

  @override
  String get ruleCheckForUpdates => 'अपडेट के लिए जाँच करें';

  @override
  String get scanInstructionFront => 'सामने का लेबल स्कैन करें';

  @override
  String get scanInstructionLeft => 'बायीं ओर स्कैन करें';

  @override
  String get scanInstructionRight => 'दायीं ओर स्कैन करें';

  @override
  String get scanInstructionAlign => 'लेबल को फ्रेम के अंदर संरेखित करें';

  @override
  String get scanStatusSearching => 'खोज रहा है...';

  @override
  String get scanStatusLabelDetected => 'लेबल का पता चला';

  @override
  String get scanStatusHoldSteady => 'स्थिर रखें';

  @override
  String get scanStatusCaptured => 'कैप्चर हो गया!';

  @override
  String get scanBtnRetake => 'फिर से लें';

  @override
  String get scanBtnContinue => 'जारी रखें';

  @override
  String get scanSideFront => 'सामने';

  @override
  String get scanSideLeft => 'बायां';

  @override
  String get scanSideRight => 'दायां';

  @override
  String get scanBtnAnalyze => 'विश्लेषण करें';

  @override
  String scanStatusCapturedTitle(String side) {
    return '✓ $side कैप्चर हो गया';
  }

  @override
  String scanProgressText(int completed, int total) {
    return '$completed/$total पूरा हुआ';
  }

  @override
  String get analysisReportTitle => 'विश्लेषण रिपोर्ट';

  @override
  String get navHome => 'होम';

  @override
  String get navHistory => 'इतिहास';

  @override
  String get navReports => 'रिपोर्ट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get navScan => 'स्कैन करें';

  @override
  String get msgProfileUpdated => 'प्रोफ़ाइल सफलतापूर्वक अपडेट की गई';

  @override
  String get editEmail => 'ईमेल पता';

  @override
  String get errEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get errEmailInvalid => 'एक वैध ईमेल दर्ज करें';

  @override
  String get editPhone => 'फ़ोन नंबर';

  @override
  String get errPhoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get errPhoneInvalid => 'फ़ोन नंबर 10 अंकों का होना चाहिए';

  @override
  String get btnSaveChanges => 'परिवर्तन सहेजें';

  @override
  String get errNameRequired => 'नाम आवश्यक है';

  @override
  String get notificationSettingsTitle => 'अधिसूचना सेटिंग्स';

  @override
  String get ruleLmpcTitle => 'LMPC अधिनियम अपडेट';

  @override
  String get ruleLmpcSubtitle =>
      'इलेक्ट्रॉनिक्स के लिए नए पैकेजिंग दिशानिर्देश';

  @override
  String get ruleFssaiTitle => 'FSSAI नए नियम';

  @override
  String get ruleFssaiSubtitle => 'अद्यतन एलर्जीन घोषणा नियम';

  @override
  String get ruleDigitalEvidenceTitle => 'डिजिटल साक्ष्य प्रोटोकॉल';

  @override
  String get ruleDigitalEvidenceSubtitle =>
      'डिजिटल छवियों के लिए स्वीकार्य प्रारूप';
}
