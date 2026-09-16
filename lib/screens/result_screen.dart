import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '../config/app_colors.dart';
import '../config/constants.dart';
import '../models/scan_result.dart';
import '../models/violation.dart';
import '../providers/scan_provider.dart';
import '../services/report_generator.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = context.watch<ScanProvider>();
    final scanResult = scanProvider.currentScan;

    if (scanProvider.isScanning || scanResult == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.cardSurface,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isReviewRequired = scanResult.violations.any(
      (v) => v.severity == Constants.severityMajor || v.severity == Constants.severityCritical,
    );

    // Calculate overall confidence (average of all violations, or 100 if compliant)
    double confidence = 100.0;
    if (scanResult.violations.isNotEmpty) {
      confidence = scanResult.violations.map((v) => v.confidence).reduce((a, b) => a + b) / scanResult.violations.length;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'LM-GUARDIAN',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Card
            _buildStatusCard(isReviewRequired, confidence),

            const SizedBox(height: 16),

            // Product Summary Card
            _buildProductCard(scanResult),

            const SizedBox(height: 16),

            // Checklist Analysis
            _buildChecklistCard(scanResult),

            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(context, scanResult),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isReviewRequired, double confidence) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReviewRequired
              ? AppColors.warningLight
              : AppColors.successLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isReviewRequired ? Icons.warning_amber_rounded : Icons.check_circle,
                    color: isReviewRequired
                        ? AppColors.warning
                        : AppColors.success,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isReviewRequired ? 'REVIEW REQUIRED' : 'COMPLIANT',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isReviewRequired
                          ? AppColors.warning
                          : AppColors.success,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${confidence.toInt()}%',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Confidence Score',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isReviewRequired
                ? 'Manual verification needed for regulatory compliance.'
                : 'Product meets all Legal Metrology requirements.',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ScanResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: result.imageBytes != null && result.imageBytes!.isNotEmpty
                ? Image.memory(result.imageBytes!.first, fit: BoxFit.cover)
                : (result.imagePaths.isNotEmpty && !kIsWeb)
                    ? Image.file(File(result.imagePaths.first), fit: BoxFit.cover)
                    : const Icon(Icons.medication, color: AppColors.textMuted, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.productName.isEmpty ? 'Unknown Product' : result.productName,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.brand.isEmpty ? 'Unknown Manufacturer' : result.brand,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard(ScanResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checklist Analysis',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...result.violations.map((v) => _ExpandableChecklistItem(violation: v)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ScanResult result) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
               // Evidence view logic here if any
            },
            icon: const Icon(Icons.folder_open_outlined, size: 20),
            label: const Text(
              'VIEW EVIDENCE',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {
               ReportGenerator().generateAndPrintReport(result);
            },
            icon: const Icon(Icons.description_outlined, size: 20),
            label: const Text(
              'GENERATE REPORT',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpandableChecklistItem extends StatefulWidget {
  final Violation violation;

  const _ExpandableChecklistItem({required this.violation});

  @override
  State<_ExpandableChecklistItem> createState() => _ExpandableChecklistItemState();
}

class _ExpandableChecklistItemState extends State<_ExpandableChecklistItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    Color bgColor;
    Color textColor;
    String statusText;
    IconData icon;

    if (widget.violation.status == Constants.statusPass) {
      iconColor = AppColors.success;
      bgColor = Colors.transparent;
      textColor = AppColors.success;
      statusText = 'Verified';
      icon = Icons.check_circle;
    } else if (widget.violation.severity == Constants.severityCritical) {
      iconColor = AppColors.danger;
      bgColor = AppColors.dangerLight;
      textColor = AppColors.danger;
      statusText = 'Missing';
      icon = Icons.cancel;
    } else {
      iconColor = AppColors.warning;
      bgColor = AppColors.warningLight;
      textColor = AppColors.warning;
      statusText = 'Flagged';
      icon = Icons.error;
    }

    final isVerified = statusText == 'Verified';

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isVerified
              ? const Border(
                  bottom: BorderSide(color: AppColors.border),
                )
              : null,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(icon, color: iconColor, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.violation.ruleName,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textMuted,
                        size: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 44, right: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.violation.description,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline, size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.violation.suggestion,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.violation.ruleCitation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Citation: ${widget.violation.ruleCitation}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
