import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../providers/scan_provider.dart';
import '../../providers/auth_provider.dart';
import '../theme/stitch_theme.dart';
import '../../models/batch_inspection.dart';
import '../../rules/rule_models.dart';
import '../../config/constants.dart';

class BatchSummaryScreen extends StatefulWidget {
  const BatchSummaryScreen({super.key});

  @override
  State<BatchSummaryScreen> createState() => _BatchSummaryScreenState();
}

class _BatchSummaryScreenState extends State<BatchSummaryScreen> {
  late BatchInspection _batch;

  @override
  void initState() {
    super.initState();
    final scanProvider = context.read<ScanProvider>();
    _batch = BatchInspection(
      id: 'BCH-${DateTime.now().millisecondsSinceEpoch}',
      shopName: scanProvider.batchShopName ?? 'Unknown Shop',
      location: scanProvider.batchLocation ?? 'Unknown Location',
      date: scanProvider.batchDate ?? DateTime.now(),
      products: List.from(scanProvider.batchResults),
    );
  }

  Future<void> _generateBatchReport(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final pdf = pw.Document();
    final inspectorId = context.read<AuthProvider>().inspectorId ?? 'N/A';

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('LabelGuard — Batch Inspection Report', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Batch ID: ${_batch.id}'),
            pw.Text('Date: ${_batch.date.toLocal().toString().split(' ')[0]}'),
            pw.Text('Shop/Establishment: ${_batch.shopName}'),
            pw.Text('Location: ${_batch.location}'),
            pw.Text('Inspector ID: $inspectorId'),
            pw.SizedBox(height: 20),
            pw.Text('Summary', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Text('Total Products Inspected: ${_batch.totalProducts}'),
            pw.Text('Total Violations Found: ${_batch.totalViolations}'),
            pw.Text('Total Estimated Penalty: Rs. ${_batch.totalPenalty}'),
            pw.SizedBox(height: 20),
            pw.Text('Product Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.SizedBox(height: 10),
            ..._batch.products.map((product) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Product: ${product.productName ?? 'Unknown'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Violations: ${product.violations?.length ?? 0}'),
                  if (product.violations != null && product.violations!.isNotEmpty)
                    pw.TableHelper.fromTextArray(
                      headers: ['Rule', 'Description', 'Severity'],
                      data: product.violations!.map((v) => [v.rule.title, v.suggestion, v.severity.name]).toList(),
                    ),
                  pw.SizedBox(height: 10),
                ]
              );
            }),
            pw.Spacer(),
            pw.Divider(),
            pw.Text('This report is generated electronically by LabelGuard under SIH26034 | Ministry of Consumer Affairs', style: const pw.TextStyle(fontSize: 10)),
          ];
        },
      ),
    );

    await Future.delayed(const Duration(seconds: 1)); // Mock generation delay
    if (context.mounted) Navigator.pop(context); // Close dialog

    try {
      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${_batch.id}.pdf');
      await file.writeAsBytes(bytes);
      
      if (context.mounted) {
        Share.shareXFiles([XFile(file.path)], text: 'Batch Inspection Report - ${_batch.shopName}');
      }
    } catch (e) {
      debugPrint("Error generating/sharing PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        title: const Text('Batch Summary'),
        backgroundColor: StitchTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ScanProvider>().clearBatch();
            context.go(Constants.routeHome);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroCard(),
                  const SizedBox(height: 24),
                  Text(
                    'Products Inspected',
                    style: StitchTheme.titleLg.copyWith(
                      color: StitchTheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._batch.products.map((p) => _buildProductItem(p)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: StitchTheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton.icon(
                onPressed: () => _generateBatchReport(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate Batch Report (PDF)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: StitchTheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1917),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _batch.shopName,
            style: StitchTheme.headlineMd.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _batch.location,
            style: StitchTheme.bodySm.copyWith(
              color: const Color(0xFFD0C4BE),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Products', '${_batch.totalProducts}'),
              const SizedBox(width: 12),
              _buildStatItem('Violations', '${_batch.totalViolations}', color: const Color(0xFFDC2626)),
              const SizedBox(width: 12),
              _buildStatItem('Penalty', '₹${_batch.totalPenalty}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color color = Colors.white}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: StitchTheme.labelSm.copyWith(
              color: const Color(0xFFD0C4BE),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: StitchTheme.displayLg.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(InspectionResult product) {
    int passedCount = product.passedRules?.length ?? 0;
    int violationsCount = product.violations?.length ?? 0;
    int totalRules = passedCount + violationsCount;
    int score = totalRules > 0 ? ((passedCount / totalRules) * 100).round() : 0;
    
    String penaltyStr = (product.penaltyExposure == null || product.penaltyExposure.toString().isEmpty || product.penaltyExposure.toString() == 'None') 
        ? '₹0' : (RegExp(r'^\d+$').hasMatch(product.penaltyExposure.toString()) ? '₹${product.penaltyExposure}' : product.penaltyExposure.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: StitchTheme.outlineVariant),
      ),
      child: ExpansionTile(
        title: Text(
          product.productName ?? 'Unknown Product',
          style: StitchTheme.titleMd.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$violationsCount violations | $penaltyStr penalty',
          style: StitchTheme.bodySm.copyWith(color: StitchTheme.onSurfaceVariant),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: score >= 80 ? Colors.green.withValues(alpha: 0.1) : (score >= 50 ? Colors.orange.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1)),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$score',
            style: TextStyle(
              color: score >= 80 ? Colors.green : (score >= 50 ? Colors.orange : Colors.red),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          if (product.violations != null && product.violations!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: product.violations!.map((v) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildViolationCard(
                      title: v.rule?.title ?? "Unknown Rule",
                      description: v.suggestion ?? "No suggestion available",
                      evidence: v.evidence ?? "No evidence",
                      severity: v.severity ?? Severity.minor,
                      penaltyAmount: v.penaltyAmount ?? 0,
                    ),
                  );
                }).toList(),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("No violations found."),
            )
        ],
      ),
    );
  }

  Widget _buildViolationCard({
    required String title,
    required String description,
    required String evidence,
    required Severity severity,
    required int penaltyAmount,
  }) {
    Color leftBarColor;
    Color penaltyColor;

    switch (severity) {
      case Severity.critical:
        leftBarColor = const Color(0xFFDC2626);
        penaltyColor = const Color(0xFFDC2626);
        break;
      case Severity.major:
        leftBarColor = Colors.orange;
        penaltyColor = Colors.orange.shade900;
        break;
      case Severity.minor:
        leftBarColor = const Color(0xFFC76C00);
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E5E4)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              color: leftBarColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: StitchTheme.titleMd.copyWith(
                              color: StitchTheme.primary,
                            ),
                          ),
                        ),
                        if (penaltyAmount > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '₹$penaltyAmount',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: StitchTheme.titleMd.copyWith(
                                color: penaltyColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: StitchTheme.bodySm.copyWith(
                        color: StitchTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
