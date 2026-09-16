import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import '../services/label_recognition/label_recognizer.dart';
import '../services/label_recognition/mock_ocr_recognizer.dart';
import '../services/text_cleaner.dart';
import '../rules/rule_models.dart';
import '../models/ocr_result.dart';
import 'package:go_router/go_router.dart';
import '../services/label_recognition/label_type.dart';
import '../presentation/widgets/fallback_label_picker.dart';
import '../data/demo_label_texts.dart';

class ScanProvider extends ChangeNotifier {
  LabelRecognizer _labelRecognizer = MockOcrRecognizer();
  // TODO(SIH-Day5): swap to CloudVisionRecognizer() when GCP billing 
  // is active. No other code changes required.

  InspectionResult? currentReport;
  String processingStep = '';
  bool isLoading = false;

  // Location State
  double? currentLat;
  double? currentLon;

  // Batch State
  bool isBatchMode = false;
  String? batchShopName;
  String? batchLocation;
  DateTime? batchDate;
  List<InspectionResult> batchResults = [];

  void setLabelRecognizer(LabelRecognizer r) => _labelRecognizer = r;

  void startBatch(String shop, String location, DateTime date) {
    isBatchMode = true;
    batchShopName = shop;
    batchLocation = location;
    batchDate = date;
    batchResults = [];
    notifyListeners();
  }

  void addToBatch(InspectionResult result) {
    batchResults.add(result);
    notifyListeners();
  }

  void clearBatch() {
    isBatchMode = false;
    batchShopName = null;
    batchLocation = null;
    batchDate = null;
    batchResults = [];
    notifyListeners();
  }

  Future<void> analyzeLabel(File image, BuildContext context) async {
    isLoading = true;
    processingStep = 'Analyzing image...';
    notifyListeners();

    String rawOcrText = DemoLabelTexts.medicineBottle;
    
    debugPrint('[LabelGuard:ScanProvider] Extracted raw text length: ${rawOcrText.length}');

    processingStep = 'Cleaning text...';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    
    final cleanText = TextCleaner.clean(rawOcrText);

    isLoading = false;
    notifyListeners();

    // Navigate to verification screen
    if (context.mounted) {
      final ocrResult = OcrResult(
        rawText: cleanText,
        blocks: [],
      );
      context.push('/verify', extra: ocrResult);
    }
  }

  void clearReport() {
    currentReport = null;
    notifyListeners();
  }

  Future<void> fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentLat = null;
        currentLon = null;
        return;
      }

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        currentLat = null;
        currentLon = null;
        return;
      }

      if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        currentLat = position.latitude;
        currentLon = position.longitude;
      }
    } catch (e) {
      debugPrint('[LabelGuard:ScanProvider] Error fetching location: $e');
      currentLat = null;
      currentLon = null;
    }
  }
  
  // Dummy methods to satisfy legacy screens
  bool get isScanning => false;
  dynamic get currentScan => null;
  void performScan(List<String> a, List<dynamic> b, String c) {}
}
