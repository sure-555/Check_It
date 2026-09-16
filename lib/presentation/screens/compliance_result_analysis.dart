import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:label_guard/l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/auth_provider.dart';
import '../../providers/scan_provider.dart';
import '../theme/stitch_theme.dart';
import '../../rules/rule_models.dart';
import '../../config/constants.dart';

class ComplianceResultAnalysis extends StatelessWidget {
  const ComplianceResultAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final result = GoRouterState.of(context).extra as InspectionResult?;

      if (result == null) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.analysisReportTitle),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/scan');
              },
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'No inspection data found.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please scan a product first.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/scan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF182537),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text('Go to Scan'),
                ),
              ],
            ),
          ),
        );
      }

      dynamic res = result;
      debugPrint("Product Name: ${res.productName}");
      debugPrint("Year: ${res.manufacturingYear}");
      debugPrint("Violations count: ${res.violations?.length}");
      debugPrint("Penalty: ${res.penaltyExposure}");

      final scanProvider = context.watch<ScanProvider>();
      final isBatchMode = scanProvider.isBatchMode;

      return Scaffold(
        backgroundColor: StitchTheme.background,
        appBar: AppBar(
          backgroundColor: StitchTheme.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: StitchTheme.primary),
            onPressed: () {
              context.go('/scan');
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.analysisReportTitle,
            style: StitchTheme.headlineMd.copyWith(color: StitchTheme.primary),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: StitchTheme.primary),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isBatchMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Chip(
                    label: Text(
                      'Batch: ${scanProvider.batchResults.length} products scanned',
                    ),
                    backgroundColor: StitchTheme.primary.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: StitchTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              _buildHeroSection(result),
              const SizedBox(height: 12),
              _buildLocationString(result),
              const SizedBox(height: 24),
              if (result.violations.isEmpty && result.manualChecks.isEmpty)
                _buildSuccessState()
              else ...[
                _buildViolationsSection(result),
                const SizedBox(height: 16),
                _buildManualChecksSection(result),
              ],
              const SizedBox(height: 16),
              _buildRulesNotApplicableSection(result),
              const SizedBox(height: 32),
              if (isBatchMode)
                _buildBatchModeActions(context)
              else
                _buildRecommendedActions(context, result),
              const SizedBox(height: 32),
              _buildSignatureSection(),
            ],
          ),
        ),
      );
    } catch (e, stacktrace) {
      debugPrint("Error rendering analysis screen: $e\n$stacktrace");
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  "Analysis could not be generated. Please go back and rescan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.go('/scan');
                  },
                  child: const Text("Go Back"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildSignatureSection() {
    final box = Hive.box('settings');
    final base64Str = box.get('inspector_signature') as String?;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StitchTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inspector Signature',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: StitchTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          if (base64Str != null)
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.memory(base64Decode(base64Str), fit: BoxFit.contain),
            )
          else
            const Text(
              'No signature available. Please sign in the Digital Signature section of your profile.',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 75) return const Color(0xFFDC2626); // High Risk
    if (score >= 40) return Colors.orange; // Medium Risk
    return Colors.green; // Low Risk
  }

  // Note: Coordinates prove inspection authenticity (anti-tamper evidence)
  Widget _buildLocationString(InspectionResult result) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final dateStr = dateFormat.format(result.scannedAt);
    final timeStr = timeFormat.format(result.scannedAt);

    String locStr = "Location unavailable";
    if (result.latitude != null && result.longitude != null) {
      locStr =
          "${result.latitude!.toStringAsFixed(5)}, ${result.longitude!.toStringAsFixed(5)}";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, size: 14, color: Color(0xFFA8A29E)),
        const SizedBox(width: 4),
        Text(
          "$locStr · $dateStr, $timeStr",
          style: StitchTheme.labelSm.copyWith(color: const Color(0xFFA8A29E)),
        ),
      ],
    );
  }

  Widget _buildHeroSection(InspectionResult result) {
    dynamic res = result;
    int passedCount = res.passedRules?.length ?? 0;
    int violationsCount = res.violations?.length ?? 0;
    int totalRules = passedCount + violationsCount;
    int score =
        res.riskScore ??
        (totalRules > 0 ? ((passedCount / totalRules) * 100).round() : 0);

    String displayName =
        (res.productName == null ||
            res.productName.toString().trim().isEmpty ||
            res.productName.toString() == 'Unknown Product')
        ? "Analyzed Label"
        : res.productName.toString().trim();

    String rawPenaltyStr = res.penaltyExposure?.toString() ?? '';
    bool isCapped = rawPenaltyStr.contains('(capped from');

    final numberFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    String formattedAmount = numberFormat.format(res.totalPenalty ?? 0);

    String captionText = isCapped
        ? rawPenaltyStr.substring(rawPenaltyStr.indexOf('(capped from')).trim()
        : '(within Sec 36(1) limit)';

    bool isCritical =
        res.riskLevel?.toString().toUpperCase().contains('CRITICAL') == true ||
        res.riskLevel?.toString().toUpperCase().contains('HIGH') == true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF352F2C), // surface-container-highest
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayName,
            style: StitchTheme.titleLg.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: score / 100.0,
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFF4D4540),
                      color: _getScoreColor(score),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score',
                        style: StitchTheme.displayLg.copyWith(
                          color: _getScoreColor(score),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        'Risk Score',
                        style: StitchTheme.labelSm.copyWith(
                          color: const Color(0xFFD0C4BE),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Est. Penalty',
                      style: StitchTheme.labelSm.copyWith(
                        color: const Color(0xFFA8A29E),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedAmount,
                      style: StitchTheme.headlineMd.copyWith(
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      captionText,
                      style: StitchTheme.labelSm.copyWith(
                        color: const Color(0xFFA8A29E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isCritical) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withValues(alpha: 0.2),
                          border: Border.all(
                            color: const Color(0xFFDC2626)
                                .withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning,
                              color: Color(0xFFDC2626),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Critical Status',
                              style: StitchTheme.labelSm.copyWith(
                                color: const Color(0xFFDC2626),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF059669).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF059669), size: 48),
          const SizedBox(height: 16),
          Text(
            'All LMPC checks passed',
            textAlign: TextAlign.center,
            style: StitchTheme.bodyLg.copyWith(
              color: const Color(0xFF059669),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No violations detected. Product appears compliant.',
            textAlign: TextAlign.center,
            style: StitchTheme.bodyMd.copyWith(color: const Color(0xFF059669)),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationsSection(InspectionResult result) {
    dynamic res = result;
    List violations = res.violations ?? [];
    if (violations.isEmpty) {
      return _buildSuccessState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Identified Violations',
              style: StitchTheme.titleLg.copyWith(
                color: StitchTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${violations.length} Total',
              style: StitchTheme.bodySm.copyWith(
                color: StitchTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...violations.map((v) {
          try {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildViolationCard(
                title: v.rule?.title ?? "Unknown Rule",
                description: v.suggestion ?? "No suggestion available",
                evidence: v.evidence ?? "No evidence",
                severity: v.severity ?? Severity.minor,
                penaltyAmount: v.penaltyAmount ?? 0,
                id: "V-${v.rule?.id ?? DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
              ),
            );
          } catch (e) {
            debugPrint("Error rendering violation card: $e");
            return const SizedBox.shrink();
          }
        }),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE7E5E4)),
              borderRadius: BorderRadius.circular(16),
              color: Colors.transparent,
            ),
            child: Text(
              'View all ${violations.length} violations',
              textAlign: TextAlign.center,
              style: StitchTheme.titleLg.copyWith(color: StitchTheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualChecksSection(InspectionResult result) {
    if (result.manualChecks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MANUAL CHECKS REQUIRED',
          style: StitchTheme.labelMd.copyWith(
            color: StitchTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        ...result.manualChecks.map(
          (rule) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildManualCheckCard(rule),
          ),
        ),
      ],
    );
  }

  Widget _buildRulesNotApplicableSection(InspectionResult result) {
    if (result.notApplicableRules.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      title: Text(
        'Rules Not Applicable (${result.notApplicableRules.length})',
        style: StitchTheme.titleMd.copyWith(
          color: StitchTheme.onSurfaceVariant,
        ),
      ),
      children: result.notApplicableRules.map((rule) {
        return ListTile(
          title: Text(rule.title, style: StitchTheme.bodyMd),
          subtitle: Text(
            'Rule introduced in ${rule.effectiveFromYear}, not applicable for ${result.manufacturingYear} products.',
            style: StitchTheme.bodySm,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildViolationCard({
    required String title,
    required String description,
    required String evidence,
    required Severity severity,
    required int penaltyAmount,
    String? id,
  }) {
    Color leftBarColor;
    Color penaltyColor;

    switch (severity) {
      case Severity.critical:
        leftBarColor = const Color(0xFFDC2626); // red-600
        penaltyColor = const Color(0xFFDC2626);
        break;
      case Severity.major:
        leftBarColor = Colors.orange;
        penaltyColor = Colors.orange.shade900;
        break;
      case Severity.minor:
        leftBarColor = const Color(
          0xFFC76C00,
        ); // on-tertiary-container from stitch
        penaltyColor = const Color(0xFFC76C00);
        break;
      default:
        leftBarColor = StitchTheme.outlineVariant;
        penaltyColor = StitchTheme.onSurfaceVariant;
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E5E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1C1917), // 5% opacity of primary
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 8, color: leftBarColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                id ?? 'V-1000',
                                style: StitchTheme.bodySm.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: StitchTheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: StitchTheme.titleLg.copyWith(
                                  color: StitchTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (penaltyAmount > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '₹$penaltyAmount',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: StitchTheme.titleLg.copyWith(
                                color: penaltyColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: StitchTheme.bodySm.copyWith(
                        color: StitchTheme.onSurfaceVariant,
                      ),
                    ),
                    if (evidence.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF0E6E0,
                          ), // surface-container-high
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.format_quote,
                              size: 16,
                              color: StitchTheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                evidence,
                                style: StitchTheme.bodySm.copyWith(
                                  color: StitchTheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualCheckCard(Rule rule) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool verified = false;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: StitchTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: StitchTheme.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: verified,
                onChanged: (val) {
                  setState(() => verified = val ?? false);
                },
                activeColor: StitchTheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rule.title,
                      style: StitchTheme.titleLg.copyWith(
                        color: StitchTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rule.guidance,
                      style: StitchTheme.bodyMd.copyWith(
                        color: StitchTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecommendedActions(
    BuildContext context,
    InspectionResult result,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 1,
          color: const Color(0xFFE7E5E4),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            if (context.read<AuthProvider>().isInspector) {
              // Action for inspector
            } else {
              _showInspectorOnlyPopup(context);
            }
          },
          icon: const Icon(Icons.gavel, size: 18),
          label: const Text('Issue Legal Notice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C1917),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _draftComplaint(context, result),
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share Report'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1C1917),
                  side: const BorderSide(color: Color(0xFF1C1917), width: 2),
                  minimumSize: const Size(double.infinity, 52),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _generateEvidenceReport(context, result),
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('Full Details'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1C1917),
                  side: const BorderSide(color: Color(0xFFE7E5E4)),
                  minimumSize: const Size(double.infinity, 52),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBatchModeActions(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () => context.go(Constants.routeScan),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: Color(0xFF1C1917)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: const Text(
            'Add Another Product',
            style: TextStyle(
              color: Color(0xFF1C1917),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.push('/batch_summary'),
          style: ElevatedButton.styleFrom(
            backgroundColor: StitchTheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: const Text(
            'Finish Batch',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<void> _generateEvidenceReport(
    BuildContext context,
    InspectionResult result,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'LabelGuard — Legal Metrology Inspection Report',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Report ID: LMG-${DateTime.now().millisecondsSinceEpoch}',
              ),
              if (result.latitude != null && result.longitude != null)
                pw.Text(
                  'Location: ${result.latitude!.toStringAsFixed(5)}, ${result.longitude!.toStringAsFixed(5)} · ${DateFormat('MMM d, yyyy, h:mm a').format(result.scannedAt)}',
                  style: const pw.TextStyle(color: PdfColors.grey),
                )
              else
                pw.Text(
                  'Location: Location unavailable · ${DateFormat('MMM d, yyyy, h:mm a').format(result.scannedAt)}',
                  style: const pw.TextStyle(color: PdfColors.grey),
                ),
              pw.Text(
                'Inspector: Inspector Rajesh Kumar, ID: LM-2024-IN-78432',
              ),
              pw.Text('Product: ${result.productName}'),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Container(
                  width: 200,
                  height: 150,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Center(child: pw.Text('[Product Label Image]')),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Detected Violations',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(height: 10),
              if (result.violations.isNotEmpty)
                pw.TableHelper.fromTextArray(
                  headers: ['Rule', 'Description', 'Severity'],
                  data: result.violations
                      .map((v) => [v.rule.title, v.suggestion, v.severity.name])
                      .toList(),
                )
              else
                pw.Text('No violations detected.'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total Penalty Exposure: ${result.penaltyExposure}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Text(
                'This report is generated electronically by LabelGuard under SIH26034 | Ministry of Consumer Affairs',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          );
        },
      ),
    );

    await Future.delayed(const Duration(seconds: 1)); // Mock generation delay

    if (context.mounted) {
      Navigator.of(context).pop(); // Dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evidence Report saved to Downloads')),
      );
    }
  }

  Future<void> _draftComplaint(
    BuildContext context,
    InspectionResult result,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('To: The District Legal Metrology Officer'),
              pw.Text(
                'From: Inspector Rajesh Kumar, Ministry of Consumer Affairs',
              ),
              pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Subject: Complaint Regarding Non-Compliance of LM(PC) Rules, 2011',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Reference: Inspection Report ID: LMG-XXXX'),
              pw.SizedBox(height: 20),
              pw.Text('Sir/Madam,'),
              pw.SizedBox(height: 10),
              pw.Text(
                'During a routine inspection on ${DateTime.now().toString().split(' ')[0]}, the product "${result.productName}" was found violating the following Legal Metrology (Packaged Commodities) Rules, 2011.',
              ),
              pw.SizedBox(height: 10),
              if (result.violations.isNotEmpty)
                pw.TableHelper.fromTextArray(
                  headers: ['Rule', 'Description', 'Severity'],
                  data: result.violations
                      .map((v) => [v.rule.title, v.suggestion, v.severity.name])
                      .toList(),
                )
              else
                pw.Text('No violations detected.'),
              pw.SizedBox(height: 20),
              pw.Text(
                'You are requested to take appropriate action under the Legal Metrology Act, 2009.',
              ),
              pw.SizedBox(height: 40),
              pw.Text('Yours sincerely,'),
              pw.Text('Inspector Rajesh Kumar'),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();

    if (context.mounted) {
      Navigator.of(context).pop(); // Dismiss loading

      try {
        final xfile = XFile.fromData(
          bytes,
          mimeType: 'application/pdf',
          name: 'Complaint_Letter.pdf',
        );
        // ignore: deprecated_member_use
        await Share.shareXFiles([xfile], text: 'Complaint Letter');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Complaint letter drafted. Share via Email/WhatsApp.',
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Complaint letter drafted. Share via Email/WhatsApp.',
              ),
            ),
          );
        }
      }
    }
  }

  void _showInspectorOnlyPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inspector Only'),
        content: const Text(
          'This action requires inspector privileges. Guest and citizen users cannot perform this action.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
