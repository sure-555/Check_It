import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/scan_result.dart';
import '../models/violation.dart';
import '../rules/rule_models.dart';

class LocalStorageService {
  static const String scanBoxName = 'scans';
  static const String inspectionsBoxName = 'inspections';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ScanResultAdapter());
    Hive.registerAdapter(ViolationAdapter());
    
    await Hive.openBox<ScanResult>(scanBoxName);
    await Hive.openBox<String>(inspectionsBoxName);
    await Hive.openBox('settings');
    await Hive.openBox('profileBox');
  }

  Box<ScanResult> get _scanBox => Hive.box<ScanResult>(scanBoxName);
  Box<String> get _inspectionsBox => Hive.box<String>(inspectionsBoxName);

  Future<void> saveScan(ScanResult result) async {
    await _scanBox.put(result.id, result);
  }

  List<ScanResult> getAllScans() {
    return _scanBox.values.toList()..sort((a, b) => b.scanDate.compareTo(a.scanDate));
  }

  List<ScanResult> getScansByUser(String userId) {
    return _scanBox.values
        .where((s) => s.inspectorId == userId)
        .toList()
        ..sort((a, b) => b.scanDate.compareTo(a.scanDate));
  }

  Future<void> deleteScan(String id) async {
    await _scanBox.delete(id);
  }

  Future<void> clearAll() async {
    await _scanBox.clear();
  }

  // --- New Inspection Data (JSON) Methods ---

  Future<void> saveInspection(InspectionResult result) async {
    final String key = result.scannedAt.millisecondsSinceEpoch.toString();
    final String jsonString = jsonEncode(result.toJson());
    await _inspectionsBox.put(key, jsonString);
  }

  List<InspectionResult> getAllInspections() {
    final List<InspectionResult> results = [];
    for (var value in _inspectionsBox.values) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(value);
        results.add(InspectionResult.fromJson(jsonMap));
      } catch (e) {
        print("Error decoding inspection: $e");
      }
    }
    results.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return results;
  }

  Future<void> deleteInspection(InspectionResult result) async {
    // Find the key by matching the scannedAt timestamp which we used as key
    final String key = result.scannedAt.millisecondsSinceEpoch.toString();
    await _inspectionsBox.delete(key);
  }
}
