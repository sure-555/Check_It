import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/stitch_theme.dart';
import '../../rules/rule_engine.dart';
import '../../models/ocr_result.dart';

import 'package:provider/provider.dart';

import '../../providers/scan_provider.dart';
import '../../services/local_storage_service.dart';

class VerificationScreen extends StatefulWidget {
  final OcrResult ocrResult;

  const VerificationScreen({super.key, required this.ocrResult});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late TextEditingController _textController;
  bool _isManualEntry = false;

  // Manual entry controllers
  final _productNameCtrl = TextEditingController();
  final _netWeightCtrl = TextEditingController();
  final _mrpCtrl = TextEditingController();
  final _mfgDateCtrl = TextEditingController();
  final _fssaiCtrl = TextEditingController();
  final _manufacturerCtrl = TextEditingController();

  int _selectedYear = 2024;

  @override
  void initState() {
    super.initState();
    String cleanText = _cleanupText(widget.ocrResult.rawText);
    _textController = TextEditingController(text: cleanText);

    // Auto-detect year if possible, else default to current but ask user
    final yearMatch = RegExp(r'\b(201[1-9]|202[0-5])\b').firstMatch(cleanText);
    if (yearMatch != null) {
      _selectedYear = int.parse(yearMatch.group(1)!);
    }
  }

  String _cleanupText(String text) {
    if (text.isEmpty) return text;
    // 1. Fix common OCR errors
    String cleaned = text
        .replaceAll(RegExp(r'\b0\b'), 'O')
        .replaceAll(RegExp(r'\b1\b(?![\d])'), 'l')
        .replaceAll(RegExp(r'\b5\b(?![\d])'), 'S')
        .replaceAll(RegExp(r'\bPoteto\b', caseSensitive: false), 'Potato');

    // 2. Fix spacing: MRP:120/- -> MRP: 120/-
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(MRP|Net Weight|FSSAI)\s*:\s*([^\s])', caseSensitive: false),
      (match) {
        return '${match.group(1)}: ${match.group(2)}';
      },
    );

    // 3. Remove garbage alphanumeric strings over 20 chars with no spaces
    final words = cleaned.split(RegExp(r'\s+'));
    final filteredWords = words.where((w) {
      if (w.length > 20 && !w.contains(RegExp(r'[^a-zA-Z0-9]'))) {
        return false;
      }
      return true;
    }).toList();

    return filteredWords.join(' ');
  }

  void _runAnalysis() async {
    final scanProvider = context.read<ScanProvider>();
    final lat = scanProvider.currentLat;
    final lon = scanProvider.currentLon;

    if (_isManualEntry) {
      // Build a fake block list from manual entry
      final fakeText =
          "Product: ${_productNameCtrl.text}\n"
          "Net Weight: ${_netWeightCtrl.text}\n"
          "MRP: ${_mrpCtrl.text}\n"
          "MFG Date: ${_mfgDateCtrl.text}\n"
          "FSSAI No: ${_fssaiCtrl.text}\n"
          "Manufactured By: ${_manufacturerCtrl.text}";

      final result = RuleEngine.analyze(
        blocks: [],
        rawText: fakeText,
        manufacturingYear: _selectedYear,
        latitude: lat,
        longitude: lon,
      );
      await LocalStorageService().saveInspection(result);
      if (mounted) context.go('/result', extra: result);
    } else {
      final result = RuleEngine.analyze(
        blocks: widget.ocrResult.blocks,
        rawText: _textController.text,
        manufacturingYear: _selectedYear,
        latitude: lat,
        longitude: lon,
      );
      await LocalStorageService().saveInspection(result);
      if (mounted) context.go('/result', extra: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLowConfidence = _isGarbageText(widget.ocrResult.rawText);

    if (isLowConfidence && !_isManualEntry) {
      return Scaffold(
        appBar: AppBar(title: const Text('Low Confidence Scan')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 64,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Text extraction unclear. Please retake photo or manually enter label details.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.go('/scan'),
                  child: const Text('Retake Photo'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isManualEntry = true),
                  child: const Text('Manual Entry Mode'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspector Verification'),
        backgroundColor: StitchTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isManualEntry ? 'Manual Entry' : 'Verify OCR Text',
                  style: StitchTheme.titleLg,
                ),
                if (!_isManualEntry)
                  TextButton(
                    onPressed: () => setState(() => _isManualEntry = true),
                    child: const Text('Switch to Manual'),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Year Dropdown
            DropdownButtonFormField<int>(
              initialValue: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Select Manufacturing Year',
                border: OutlineInputBorder(),
              ),
              items: List.generate(15, (i) => 2011 + i)
                  .map(
                    (y) =>
                        DropdownMenuItem(value: y, child: Text(y.toString())),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedYear = val);
              },
            ),
            const SizedBox(height: 16),

            if (!_isManualEntry) ...[
              const Text("Review and correct the extracted text below:"),
              const SizedBox(height: 8),
              TextField(
                controller: _textController,
                maxLines: 15,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ] else ...[
              _buildManualField("Product Name", _productNameCtrl),
              _buildManualField("Net Weight", _netWeightCtrl),
              _buildManualField("MRP", _mrpCtrl),
              _buildManualField("MFG Date", _mfgDateCtrl),
              _buildManualField("FSSAI No.", _fssaiCtrl),
              _buildManualField("Manufacturer", _manufacturerCtrl),
            ],

            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go('/scan'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Retake Photo'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _runAnalysis,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: StitchTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Run Analysis'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  bool _isGarbageText(String text) {
    if (text.isEmpty) return true;
    final alphaNumericCount = text
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .length;
    final totalCount = text.replaceAll(RegExp(r'\s+'), '').length;
    if (totalCount == 0) return true;

    int wordsCount = text
        .split(RegExp(r'\s+'))
        .where((w) => RegExp(r'[a-zA-Z]').hasMatch(w))
        .length;
    if (wordsCount < 8) return true;

    if ((totalCount - alphaNumericCount) / totalCount > 0.4) return true;
    return false;
  }
}
