import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../presentation/screens/main_navigation_screen.dart';
import '../presentation/screens/product_scanner_interface.dart';
import '../presentation/screens/compliance_result_analysis.dart';
import '../presentation/screens/verification_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/offline_sync_screen.dart';
import '../presentation/screens/digital_signature_screen.dart';
import '../presentation/screens/about_screen.dart';
import '../presentation/screens/batch_setup_screen.dart';
import '../presentation/screens/batch_summary_screen.dart';
import '../models/ocr_result.dart';
import '../rules/rule_models.dart';
import '../presentation/screens/report_detail_screen.dart';
import 'constants.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Constants.routeLogin,
  redirect: (context, state) {
    // Check if we are logged in
    final box = Hive.box('settings');
    final isLoggedIn = box.get('isLoggedIn', defaultValue: false) as bool;
    
    final isGoingToLogin = state.matchedLocation == Constants.routeLogin;

    if (isLoggedIn && isGoingToLogin) {
      return Constants.routeHome; // Skip login
    }
    
    return null; // No redirect needed
  },
  routes: [
    GoRoute(
      path: Constants.routeLogin,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      // Note: routeSplash was '/', assuming routeHome is the same or we should change it
      path: Constants.routeSplash,
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: Constants.routeHome,
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: Constants.routeScan,
      builder: (context, state) => const ProductScannerInterface(),
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) {
        final ocrResult = state.extra as OcrResult;
        return VerificationScreen(ocrResult: ocrResult);
      },
    ),
    GoRoute(
      path: Constants.routeResult,
      builder: (context, state) => const ComplianceResultAnalysis(),
    ),
    GoRoute(
      path: '/offline_sync',
      builder: (context, state) => const OfflineSyncScreen(),
    ),
    GoRoute(
      path: '/digital_signature',
      builder: (context, state) => const DigitalSignatureScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/batch_setup',
      builder: (context, state) => const BatchSetupScreen(),
    ),
    GoRoute(
      path: '/batch_summary',
      builder: (context, state) => const BatchSummaryScreen(),
    ),
    GoRoute(
      path: '/report-detail',
      builder: (context, state) {
        final report = state.extra as InspectionResult;
        return ReportDetailScreen(report: report);
      },
    ),
  ],
);
