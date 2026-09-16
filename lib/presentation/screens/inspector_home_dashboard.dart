import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import '../theme/stitch_theme.dart';
import '../../services/local_storage_service.dart';
import '../../rules/rule_models.dart';
import 'product_scanner_interface.dart';
import 'package:label_guard/l10n/app_localizations.dart';

class InspectorHomeDashboard extends StatefulWidget {
  const InspectorHomeDashboard({super.key});

  @override
  State<InspectorHomeDashboard> createState() => _InspectorHomeDashboardState();
}

class _InspectorHomeDashboardState extends State<InspectorHomeDashboard> {
  List<InspectionResult> _todayInspections = [];

  @override
  void initState() {
    super.initState();
    _loadTodayInspections();
  }

  void _loadTodayInspections() {
    final all = LocalStorageService().getAllInspections();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    _todayInspections = all.where((r) {
      final d = r.scannedAt;
      return DateTime(d.year, d.month, d.day) == today;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Reload on every build just in case we returned from another screen
    _loadTodayInspections();

    return Scaffold(
      backgroundColor: StitchTheme.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 24.0,
            bottom: 100.0, // Space for Bottom Nav
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopAppBar(),
              const SizedBox(height: 24),
              _buildHeroCard(context),
              const SizedBox(height: 32),
              _buildStatisticsSection(context),
              const SizedBox(height: 32),
              _buildPenaltyExposureStrip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'CheckIt',
          style: StitchTheme.headlineMd.copyWith(
            color: StitchTheme.primary,
          ),
        ),
        Builder(
          builder: (context) => TextButton(
            onPressed: () {
              context.push('/batch_setup');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Batch Mode',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: StitchTheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductScannerInterface(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), 
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1C1917), Color(0xFF292524)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Radial Gradient highlight on top right
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Colors.white.withValues(alpha: 0.7), size: 14),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.dashActiveShift,
                          style: StitchTheme.labelMd.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.dashInspectorDashboard,
                    style: StitchTheme.headlineMd.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.dashReadyToBegin,
                    style: StitchTheme.bodyMd.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner,
                          color: Color(0xFF1C1917),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.dashScanPackageLabel,
                            style: StitchTheme.bodyMd.copyWith(
                              color: const Color(0xFF1C1917),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    final int inspectedCount = _todayInspections.length;
    final int compliantCount = _todayInspections.where((r) => r.isCompliant).length;
    final int violationsCount = _todayInspections.fold(0, (sum, r) => sum + r.violations.length);
    final int highRiskCount = _todayInspections.where((r) => r.riskScore <= 30).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.dashTodaysOverview,
                style: StitchTheme.headlineMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: StitchTheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.dashLastUpdated,
                style: StitchTheme.bodySm.copyWith(
                  color: StitchTheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: AppLocalizations.of(context)!.statInspected,
                      value: inspectedCount.toString(),
                      icon: Icons.checklist,
                      iconBgColor: StitchTheme.surfaceVariant,
                      iconColor: StitchTheme.onSurfaceVariant,
                      borderColor: const Color(0xFF1C1917),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: AppLocalizations.of(context)!.statCompliant,
                      value: compliantCount.toString(),
                      icon: Icons.check_circle,
                      iconBgColor: const Color(0xFF059669).withValues(alpha: 0.1),
                      iconColor: const Color(0xFF059669),
                      borderColor: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: AppLocalizations.of(context)!.statViolations,
                      value: violationsCount.toString(),
                      icon: Icons.error,
                      iconBgColor: const Color(0xFFE11D48).withValues(alpha: 0.1),
                      iconColor: const Color(0xFFE11D48),
                      borderColor: const Color(0xFFE11D48),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: AppLocalizations.of(context)!.statHighRisk,
                      value: highRiskCount.toString(),
                      icon: Icons.warning,
                      iconBgColor: const Color(0xFFD97706).withValues(alpha: 0.1),
                      iconColor: const Color(0xFFD97706),
                      borderColor: const Color(0xFFD97706),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: StitchTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: StitchTheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C1917).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: StitchTheme.labelMd.copyWith(
                          color: StitchTheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(icon, size: 14, color: iconColor),
                      ),
                    ),
                  ],
                ),
                Text(
                  value,
                  style: StitchTheme.displayLg.copyWith(
                    color: StitchTheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyExposureStrip() {
    final int totalInspections = _todayInspections.length;
    final int totalViolations = _todayInspections.fold(0, (sum, report) => sum + report.violations.length);
    final double totalPenalty = _todayInspections.fold(0.0, (sum, report) => sum + report.totalPenalty);

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final formattedPenalty = currencyFormatter.format(totalPenalty);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E5E4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined, size: 20, color: Color(0xFF059669)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PENALTY EXPOSURE',
                    style: StitchTheme.bodySm.copyWith(
                      color: const Color(0xFF78716C),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedPenalty,
                    style: StitchTheme.headlineMd.copyWith(
                      color: const Color(0xFF1C1917),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '$totalInspections inspections · $totalViolations violations',
            style: StitchTheme.bodySm.copyWith(
              color: const Color(0xFF78716C),
            ),
          ),
        ],
      ),
    );
  }
}

