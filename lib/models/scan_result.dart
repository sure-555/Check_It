import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'violation.dart';

part 'scan_result.g.dart';

@HiveType(typeId: 0)
class ScanResult {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime scanDate;

  @HiveField(2)
  final List<String> imagePaths;

  @HiveField(3)
  final List<Violation> violations;

  @HiveField(4)
  final String productName;

  @HiveField(5)
  final String brand;

  @HiveField(6)
  final String batchNumber;

  @HiveField(7)
  final String? inspectorId;

  @HiveField(8)
  final String location;

  @HiveField(9)
  final bool isCompliant;

  @HiveField(10)
  final List<Uint8List>? imageBytes;

  ScanResult({
    required this.id,
    required this.scanDate,
    required this.imagePaths,
    required this.violations,
    required this.productName,
    required this.brand,
    required this.batchNumber,
    this.inspectorId,
    required this.location,
    required this.isCompliant,
    this.imageBytes,
  });
}
