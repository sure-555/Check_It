import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../rules/rule_models.dart';

class ReportDetailScreen extends StatelessWidget {
  final InspectionResult report;

  const ReportDetailScreen({super.key, required this.report});

  void _shareReport() {
    final String summary = '''
Inspection Report: ${report.productName}
Risk Score: ${report.riskScore}/100
Violations: ${report.violations.length}
Penalty: ₹${report.totalPenalty.toInt()}
Inspected by: ${report.inspectorId}
''';
    Share.share(summary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1917),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          report.productName,
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter', overflow: TextOverflow.ellipsis),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Stack(
              children: [
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: report.labelImageAsset != null && report.labelImageAsset!.isNotEmpty
                      ? Image.asset(
                          report.labelImageAsset!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _heroPlaceholder();
                          },
                        )
                      : _heroPlaceholder(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0x80000000), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 48, // slightly higher to account for card overlap
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.productName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.scannedAt.toLocal().toString().split('.')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Summary Card
            Transform.translate(
              offset: const Offset(0, -32),
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryStat(
                        "Risk Score",
                        "${report.riskScore}/100",
                        report.riskScore > 30 ? const Color(0xFFD97706) : const Color(0xFF1C1917),
                      ),
                      _buildSummaryStat(
                        "Violations",
                        "${report.violations.length}",
                        const Color(0xFF1C1917),
                      ),
                      _buildSummaryStat(
                        "Penalty",
                        "₹${report.totalPenalty.toInt()}",
                        const Color(0xFF1C1917),
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFFE7E5E4),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("Inspected by", style: TextStyle(color: Color(0xFF78716C), fontSize: 12, fontFamily: 'Inter')),
                          const SizedBox(width: 8),
                          Text(report.inspectorId ?? "Unknown", style: const TextStyle(color: Color(0xFF1C1917), fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(report.isCompliant ? Icons.check_circle : Icons.warning, color: report.isCompliant ? const Color(0xFF059669) : const Color(0xFFDC2626), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            report.isCompliant ? "Compliant" : "Non-Compliant",
                            style: TextStyle(color: report.isCompliant ? const Color(0xFF059669) : const Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),

            // Violations Section
            if (report.violations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 8),
                child: const Text(
                  "Detected Violations",
                  style: TextStyle(
                    color: Color(0xFF1C1917),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),

            ...report.violations.map((v) => _buildViolationCard(v)).toList(),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE7E5E4))),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C1917),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text("Generate PDF", style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF059669),
                  side: const BorderSide(color: Color(0xFF059669)),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Add to Batch", style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF78716C), fontSize: 12, fontFamily: 'Inter')),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
      ],
    );
  }

  Widget _buildViolationCard(Violation v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E5E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1917),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  v.rule.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Text(
                "₹${v.penaltyAmount}",
                style: const TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            v.rule.description,
            style: const TextStyle(
              color: Color(0xFF1C1917),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0xFFE7E5E4), width: 3)),
            ),
            child: Text(
              '"${v.evidence}"',
              style: const TextStyle(
                color: Color(0xFF78716C),
                fontSize: 13,
                fontStyle: FontStyle.italic,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Color(0xFF059669), fontSize: 13, fontFamily: 'Inter'),
              children: [
                const TextSpan(text: "Fix: ", style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: v.suggestion),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F4),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 48, color: Color(0xFFA8A29E)),
            SizedBox(height: 8),
            Text(
              'Label image not available',
              style: TextStyle(color: Color(0xFFA8A29E), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
