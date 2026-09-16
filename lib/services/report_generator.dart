import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../models/scan_result.dart';
import '../models/violation.dart';
import '../config/constants.dart';

class ReportGenerator {
  Future<void> generateAndPrintReport(ScanResult result) async {
    final pdf = pw.Document();

    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(result, dateFormat),
            pw.SizedBox(height: 20),
            _buildSummary(result),
            pw.SizedBox(height: 20),
            pw.Text(
              'Violations Details',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(),
            ...result.violations.map((v) => _buildViolationItem(v)),
            pw.SizedBox(height: 40),
            _buildFooter(result),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'LabelGuard_Report_${result.id}.pdf',
    );
  }

  pw.Widget _buildHeader(ScanResult result, DateFormat dateFormat) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'LabelGuard Inspection Report',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              result.isCompliant ? 'COMPLIANT' : 'VIOLATION FOUND',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: result.isCompliant ? PdfColors.green : PdfColors.red,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Report ID: ${result.id}',
          style: const pw.TextStyle(color: PdfColors.grey),
        ),
        if (result.location.isNotEmpty && result.location != 'Unknown')
          pw.Text(
            'Location: ${result.location} · ${dateFormat.format(result.scanDate)}',
            style: const pw.TextStyle(color: PdfColors.grey),
          )
        else
          pw.Text(
            'Location: Location unavailable · ${dateFormat.format(result.scanDate)}',
            style: const pw.TextStyle(color: PdfColors.grey),
          ),
        pw.Text(
          'Inspector ID: ${result.inspectorId}',
          style: const pw.TextStyle(color: PdfColors.grey),
        ),
      ],
    );
  }

  pw.Widget _buildSummary(ScanResult result) {
    final fails = result.violations
        .where((v) => v.status == Constants.statusFail)
        .length;
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Product: ${result.productName}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Brand: ${result.brand}'),
          pw.SizedBox(height: 10),
          pw.Text('Rules Checked: ${result.violations.length}'),
          pw.Text(
            'Rules Failed: $fails',
            style: pw.TextStyle(
              color: fails > 0 ? PdfColors.red : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildViolationItem(Violation violation) {
    final isPass = violation.status == Constants.statusPass;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Text(
                '${isPass ? "[PASS]" : "[FAIL]"} ${violation.ruleName}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: isPass ? PdfColors.green : PdfColors.red,
                ),
              ),
              pw.SizedBox(width: 8),
              if (!isPass)
                pw.Text(
                  '(${violation.severity})',
                  style: const pw.TextStyle(color: PdfColors.orange),
                ),
            ],
          ),
          pw.Text(
            'Citation: ${violation.ruleCitation}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
          pw.SizedBox(height: 4),
          pw.Text('Condition: ${violation.description}'),
          if (!isPass)
            pw.Text(
              'Action Required: ${violation.suggestion}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          pw.SizedBox(height: 8),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(ScanResult result) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(),
        pw.Text(
          'Generated by LabelGuard - Legal Metrology Compliance Scanner',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
        ),
      ],
    );
  }
}
