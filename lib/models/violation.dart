import 'package:hive/hive.dart';

part 'violation.g.dart';

@HiveType(typeId: 1)
class Violation {
  @HiveField(0)
  final String ruleId;

  @HiveField(1)
  final String ruleName;

  @HiveField(2)
  final String ruleCitation;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String suggestion;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final String severity;

  @HiveField(7)
  final double confidence;

  Violation({
    required this.ruleId,
    required this.ruleName,
    required this.ruleCitation,
    required this.description,
    required this.suggestion,
    required this.status,
    required this.severity,
    required this.confidence,
  });
}
