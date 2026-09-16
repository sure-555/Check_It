enum Severity { critical, major, minor, compliant, manualCheck }
enum RuleCategory { mrp, quantity, manufacturer, date, consumerInfo, labelFormat, categorySpecific }

class Rule {
  final String id;              // e.g., "MRP-01"
  final String title;           // e.g., "MRP must be printed"
  final String description;     // Full description
  final RuleCategory category;
  final Severity severity;
  final int effectiveFromYear;  // e.g., 2011
  final int? effectiveToYear;   // null if still active
  final bool isAutoDetectable;  // true = regex/OCR check, false = manual only
  final String guidance;        // Text shown to inspector for manual checks

  Rule({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.effectiveFromYear,
    this.effectiveToYear,
    required this.isAutoDetectable,
    required this.guidance,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category.name,
    'severity': severity.name,
    'effectiveFromYear': effectiveFromYear,
    'effectiveToYear': effectiveToYear,
    'isAutoDetectable': isAutoDetectable,
    'guidance': guidance,
  };

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: RuleCategory.values.byName(json['category'] as String),
    severity: Severity.values.byName(json['severity'] as String),
    effectiveFromYear: json['effectiveFromYear'] as int,
    effectiveToYear: json['effectiveToYear'] as int?,
    isAutoDetectable: json['isAutoDetectable'] as bool,
    guidance: json['guidance'] as String,
  );
}

class Violation {
  final Rule rule;
  final String evidence;        // OCR text snippet that triggered it
  final String suggestion;      // How to fix
  final Severity severity;
  final int penaltyAmount;

  Violation({
    required this.rule,
    required this.evidence,
    required this.suggestion,
    required this.severity,
    required this.penaltyAmount,
  });

  Map<String, dynamic> toJson() => {
    'rule': rule.toJson(),
    'evidence': evidence,
    'suggestion': suggestion,
    'severity': severity.name,
    'penaltyAmount': penaltyAmount,
  };

  factory Violation.fromJson(Map<String, dynamic> json) => Violation(
    rule: Rule.fromJson(json['rule'] as Map<String, dynamic>),
    evidence: json['evidence'] as String,
    suggestion: json['suggestion'] as String,
    severity: Severity.values.byName(json['severity'] as String),
    penaltyAmount: json['penaltyAmount'] as int,
  );
}

class InspectionResult {
  final String productName;
  final int manufacturingYear;
  final List<Violation> violations;
  final List<Rule> passedRules;
  final List<Rule> notApplicableRules;
  final List<Rule> manualChecks;
  final String riskLevel;       // HIGH / MEDIUM / LOW / COMPLIANT
  final String penaltyExposure;
  final DateTime scannedAt;
  
  // Additional fields for history reports
  final String? productType;
  final String? inspectorId;
  final int riskScore;
  final double totalPenalty;
  final bool isCompliant;
  final String? labelImageAsset;
  final bool isRepeatOffence; // Added hook for repeat offences
  final double? latitude;
  final double? longitude;

  InspectionResult({
    required this.productName,
    required this.manufacturingYear,
    required this.violations,
    required this.passedRules,
    required this.notApplicableRules,
    required this.manualChecks,
    required this.riskLevel,
    required this.penaltyExposure,
    required this.scannedAt,
    this.productType,
    this.inspectorId,
    this.riskScore = 0,
    this.totalPenalty = 0.0,
    this.isCompliant = false,
    this.labelImageAsset,
    this.isRepeatOffence = false,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'manufacturingYear': manufacturingYear,
    'violations': violations.map((v) => v.toJson()).toList(),
    'passedRules': passedRules.map((r) => r.toJson()).toList(),
    'notApplicableRules': notApplicableRules.map((r) => r.toJson()).toList(),
    'manualChecks': manualChecks.map((r) => r.toJson()).toList(),
    'riskLevel': riskLevel,
    'penaltyExposure': penaltyExposure,
    'scannedAt': scannedAt.toIso8601String(),
    'productType': productType,
    'inspectorId': inspectorId,
    'riskScore': riskScore,
    'totalPenalty': totalPenalty,
    'isCompliant': isCompliant,
    'labelImageAsset': labelImageAsset,
    'isRepeatOffence': isRepeatOffence,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory InspectionResult.fromJson(Map<String, dynamic> json) => InspectionResult(
    productName: json['productName'] as String,
    manufacturingYear: json['manufacturingYear'] as int,
    violations: (json['violations'] as List<dynamic>?)?.map((v) => Violation.fromJson(v as Map<String, dynamic>)).toList() ?? [],
    passedRules: (json['passedRules'] as List<dynamic>?)?.map((r) => Rule.fromJson(r as Map<String, dynamic>)).toList() ?? [],
    notApplicableRules: (json['notApplicableRules'] as List<dynamic>?)?.map((r) => Rule.fromJson(r as Map<String, dynamic>)).toList() ?? [],
    manualChecks: (json['manualChecks'] as List<dynamic>?)?.map((r) => Rule.fromJson(r as Map<String, dynamic>)).toList() ?? [],
    riskLevel: json['riskLevel'] as String,
    penaltyExposure: json['penaltyExposure'] as String,
    scannedAt: DateTime.parse(json['scannedAt'] as String),
    productType: json['productType'] as String?,
    inspectorId: json['inspectorId'] as String?,
    riskScore: json['riskScore'] as int? ?? 0,
    totalPenalty: (json['totalPenalty'] as num?)?.toDouble() ?? 0.0,
    isCompliant: json['isCompliant'] as bool? ?? false,
    labelImageAsset: json['labelImageAsset'] as String?,
    isRepeatOffence: json['isRepeatOffence'] as bool? ?? false,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
  );
}

