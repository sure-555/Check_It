import 'dart:math';

import '../models/ocr_result.dart';
import 'rule_models.dart';
import '../services/spatial_matcher.dart';
import 'extractors/fuzzy_matcher.dart';
import 'penalty_schedule.dart';

class RuleEngine {
  static InspectionResult analyze({
    List<OcrBlock> blocks = const [],
    required String rawText,
    int manufacturingYear = 2024,
    bool isRepeatOffence = false,
    double? latitude,
    double? longitude,
  }) {
    List<Violation> violations = [];
    String lowerText = rawText.toLowerCase();
    
    // Helper to find block by keyword
    OcrBlock? findAnchor(String keyword) {
      for (var b in blocks) {
        if (FuzzyMatcher.isMatch(keyword, b.text)) return b;
      }
      return null;
    }

    // --- BASE RULES 2011 ---

    // RULE 6.1 - Product Name Missing
    String extractedProductName = "Unknown Product";
    final lines = rawText.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    for (var line in lines) {
      final lineWords = line.split(RegExp(r'\s+'));
      if (lineWords.length >= 2 && lineWords.length <= 5) {
        bool hasBlocklist = RegExp(r'(mrp|net|weight|date|batch|ingredients|fssai|price|pkd|mfg|barcode|customer)', caseSensitive: false).hasMatch(line);
        if (!hasBlocklist) {
          extractedProductName = line;
          break;
        }
      }
    }

    if (extractedProductName == "Unknown Product") {
      violations.add(_createViolation("6.1", "Product Name Missing", RuleCategory.labelFormat, Severity.major, "No prominent product name block found"));
    }

    // RULE 6.2 & 6.3 - Net Quantity
    OcrBlock? qtyAnchor = findAnchor("Net Weight");
    OcrBlock? qtyValue = qtyAnchor != null ? SpatialMatcher.findValue(qtyAnchor, blocks) : null;
    bool hasQty = false;
    String qtyText = "";
    if (qtyValue != null) {
      hasQty = true;
      qtyText = qtyValue.text.toLowerCase();
    } else if (RegExp(r'\d+\s*(g|kg|ml|l|cm|m|pcs|units|nos)', caseSensitive: false).hasMatch(rawText)) {
      hasQty = true;
      qtyText = RegExp(r'\d+\s*(g|kg|ml|l|cm|m|pcs|units|nos)', caseSensitive: false).firstMatch(rawText)!.group(0)!.toLowerCase();
    }

    if (!hasQty) {
      violations.add(_createViolation("6.2", "Net Quantity Missing", RuleCategory.quantity, Severity.critical, "No net quantity declaration found"));
    } else {
      if (RegExp(r'(oz|pound|lb|gallon|inch|ft|yard)').hasMatch(qtyText)) {
        violations.add(_createViolation("6.3", "Net Quantity Non-Metric Unit", RuleCategory.quantity, Severity.major, "Non-metric unit found"));
      }
    }

    int rulesTotal = 20; // 16 base + 1 (2015) + 2 (2021) + 1 (2026)
    int applied = 16;
    int skippedByYear = 0;

    // RULE 6.4 & 6.4.1 & 6.5 - MRP
    OcrBlock? mrpAnchor = findAnchor("MRP");
    OcrBlock? mrpValue = mrpAnchor != null ? SpatialMatcher.findValue(mrpAnchor, blocks) : null;
    bool hasMrp = false;
    
    // FIX 8: Fix MRP Detection on Verified Text
    if (mrpValue != null) {
      hasMrp = true;
    } else if (RegExp(r'(mrp|rs\.?|₹|/-|\$)', caseSensitive: false).hasMatch(rawText) && RegExp(r'\d+').hasMatch(rawText)) {
      hasMrp = true;
    }
    
    if (!hasMrp) {
      violations.add(_createViolation("6.4", "MRP Missing", RuleCategory.mrp, Severity.critical, "No MRP or retail sale price declared"));
    } else {
      if (RegExp(r'\$|usd|euro|£', caseSensitive: false).hasMatch(rawText)) {
        violations.add(_createViolation("6.4.1", "MRP Format Invalid", RuleCategory.mrp, Severity.major, "MRP declared in foreign currency instead of INR"));
      }
      
      bool hasTaxWording = false;
      final words = lowerText.split(RegExp(r'\s+'));
      for (int i = 0; i < words.length; i++) {
        String w = words[i].replaceAll(RegExp(r'[^a-z]'), '');
        if (w == 'incl' || w == 'inclusive' || w == 'including') {
          int start = (i - 5) < 0 ? 0 : i - 5;
          int end = (i + 5) >= words.length ? words.length - 1 : i + 5;
          for (int j = start; j <= end; j++) {
            String w2 = words[j].replaceAll(RegExp(r'[^a-z]'), '');
            if (w2 == 'tax' || w2 == 'tex' || w2 == 'taxes' || w2 == 'texes') {
              hasTaxWording = true;
              break;
            }
          }
        }
        if (hasTaxWording) break;
      }
      if (!hasTaxWording) {
        violations.add(_createViolation("6.5", "MRP Tax Wording Missing", RuleCategory.mrp, Severity.minor, "MRP present but tax inclusion wording missing"));
      }
    }

    // RULE 6.6 & 6.7 - Manufacturer
    bool hasAddress = false;
    bool hasName = false;
    int addressIndex = -1;
    
    for (int i = 0; i < blocks.length; i++) {
      if (RegExp(r'\b\d{6}\b').hasMatch(blocks[i].text)) {
        hasAddress = true;
        addressIndex = i;
        break;
      }
    }
    
    if (hasAddress && addressIndex > 0) {
      // look up to 3 blocks above
      int start = (addressIndex - 3 < 0) ? 0 : addressIndex - 3;
      for (int i = addressIndex - 1; i >= start; i--) {
        String aboveText = blocks[i].text.trim();
        bool isKeyword = RegExp(r'(mrp|net|weight|date|batch|ingredients|mfg|pkd|use by|best before|fssai|rs|₹)', caseSensitive: false).hasMatch(aboveText);
        bool hasCapitalizedWord = RegExp(r'[A-Z][a-z]+').hasMatch(aboveText) || RegExp(r'^[A-Z\s]+$').hasMatch(aboveText);
        
        if (!isKeyword && hasCapitalizedWord && aboveText.length > 2) {
          hasName = true;
          break;
        }
      }
    } else if (!hasAddress) {
       // fallback for rawText
       if (RegExp(r'\b\d{6}\b').hasMatch(rawText)) {
          hasAddress = true;
          if (RegExp(r'(ltd|limited|pvt|private|inc|llp|company|foods|industries)', caseSensitive: false).hasMatch(rawText)) {
             hasName = true;
          }
       }
    }
    
    if (!hasAddress) {
      violations.add(_createViolation("6.7", "Manufacturer Address Incomplete", RuleCategory.manufacturer, Severity.major, "Manufacturer address incomplete or missing pincode"));
    } else if (!hasName) {
      violations.add(_createViolation("6.6", "Manufacturer Name Missing", RuleCategory.manufacturer, Severity.major, "Manufacturer or packer name not declared above address"));
    }

    // RULE 6.8 - MFG Date
    OcrBlock? mfgAnchor = findAnchor("MFG");
    OcrBlock? mfgValue = mfgAnchor != null ? SpatialMatcher.findValue(mfgAnchor, blocks) : null;
    if (mfgValue == null && !RegExp(r'\d{2}[/-]\d{2}[/-]\d{2,4}').hasMatch(rawText) && !RegExp(r'(mfg|pkd|packed)', caseSensitive: false).hasMatch(rawText)) {
      violations.add(_createViolation("6.8", "Date of Manufacture Missing", RuleCategory.date, Severity.major, "Date of manufacture or packing not declared"));
    }

    // RULE 6.9 - Best Before
    OcrBlock? expAnchor = findAnchor("Best Before");
    OcrBlock? expValue = expAnchor != null ? SpatialMatcher.findValue(expAnchor, blocks) : null;
    if (expValue == null && !RegExp(r'(best before|expiry|use by)', caseSensitive: false).hasMatch(rawText)) {
      violations.add(_createViolation("6.9", "Best Before / Expiry Date Missing", RuleCategory.date, Severity.major, "Best before or expiry date not declared"));
    }

    // RULE 6.10 - Batch
    OcrBlock? batchAnchor = findAnchor("Batch");
    OcrBlock? batchValue = batchAnchor != null ? SpatialMatcher.findValue(batchAnchor, blocks) : null;
    if (batchValue == null && !RegExp(r'(batch|lot|b\.?no)', caseSensitive: false).hasMatch(rawText)) {
      violations.add(_createViolation("6.10", "Batch / Lot Number Missing", RuleCategory.date, Severity.major, "Batch or lot number not declared"));
    }

    // RULE 6.11 - Ingredients
    bool isFood = FuzzyMatcher.containsAnyFoodTerm(rawText);
    if (isFood) {
      OcrBlock? ingAnchor = findAnchor("Ingredients");
      OcrBlock? ingValue = ingAnchor != null ? SpatialMatcher.findValue(ingAnchor, blocks) : null;
      if (ingValue == null && !lowerText.contains("ingredients")) {
        violations.add(_createViolation("6.11", "Ingredients List Missing", RuleCategory.labelFormat, Severity.major, "Ingredients list not found"));
      }
      
      // RULE FSSAI.1 & FSSAI.2
      // FIX 7: Fix FSSAI Extraction to Capture Full Number
      final fssaiRegex = RegExp(r'FSSAI\s*No\.?\s*[:.]?\s*(\d{8,16})', caseSensitive: false);
      String fssaiText = "";
      var fssaiMatch = fssaiRegex.firstMatch(rawText);
      if (fssaiMatch != null) {
        fssaiText = fssaiMatch.group(1) ?? "";
      } else {
        OcrBlock? fssaiAnchor = findAnchor("FSSAI");
        OcrBlock? fssaiValue = fssaiAnchor != null ? SpatialMatcher.findValue(fssaiAnchor, blocks) : null;
        fssaiText = fssaiValue?.text ?? "";
      }
      
      if (fssaiText.isEmpty && !lowerText.contains("fssai")) {
        violations.add(_createViolation("FSSAI.1", "FSSAI License Number Missing", RuleCategory.categorySpecific, Severity.critical, "FSSAI license number not declared"));
      } else if (fssaiText.isNotEmpty) {
        String digits = fssaiText.replaceAll(RegExp(r'[^\d]'), '');
        if (digits.length != 14 && digits.length != 11) {
          violations.add(_createViolation("FSSAI.2", "FSSAI License Format Invalid", RuleCategory.categorySpecific, Severity.critical, "FSSAI number has ${digits.length} digits, required 14 or 11"));
        } else if (digits.isNotEmpty && !digits.startsWith('1') && !digits.startsWith('2') && !digits.startsWith('0')) {
          violations.add(_createViolation("FSSAI.2", "FSSAI License Format Invalid", RuleCategory.categorySpecific, Severity.critical, "FSSAI number must start with 1, 2 or 0"));
        }
      }
    }

    // RULE 6.12 - Customer Care
    if (!RegExp(r'(\+91|\d{10}|@|contact|customer|helpline)', caseSensitive: false).hasMatch(rawText)) {
      violations.add(_createViolation("6.12", "Customer Care Contact Missing", RuleCategory.consumerInfo, Severity.minor, "Customer care contact not provided"));
    }

    // RULE 6.13 - Country of Origin
    if (RegExp(r'(imported|foreign)', caseSensitive: false).hasMatch(rawText) && !RegExp(r'(country of origin|made in|product of)', caseSensitive: false).hasMatch(rawText)) {
      violations.add(_createViolation("6.13", "Country of Origin Missing (Imports)", RuleCategory.manufacturer, Severity.major, "Country of origin not declared for imported product"));
    }

    // 2015 Rules
    if (manufacturingYear >= 2015) {
      applied += 1;
      // 15.1 Standard pack size is too complex for simple regex without knowing product type, skip strict check or mock it
      // 15.2 Unit sale price
      bool isMultiUnit = RegExp(r'(pack of|combo|bundle|multi-pack|multipack|box of|multi|6x|6 x|12x|12 x|set of)', caseSensitive: false).hasMatch(rawText);
      if (isMultiUnit) {
        if (!RegExp(r'(unit price|per 100g|per kg|₹/|rs/)', caseSensitive: false).hasMatch(rawText)) {
          violations.add(_createViolation("15.2", "Unit Sale Price Missing", RuleCategory.mrp, Severity.minor, "Unit sale price not declared for multi-unit pack"));
        }
      }
    } else {
      skippedByYear += 1;
    }

    // 2021 Rules
    if (manufacturingYear >= 2021) {
      applied += 2;
      bool hasBarcodeText = RegExp(r'(barcode|qr code|qr|ean|upc|gtin|scan here|digital id|traceability)', caseSensitive: false).hasMatch(rawText);
      bool hasBarcodeSequence = RegExp(r'\d{5,}').hasMatch(rawText);
      if (!hasBarcodeText && !hasBarcodeSequence) {
        violations.add(_createViolation("21.1", "QR Code / Digital Traceability Missing", RuleCategory.labelFormat, Severity.minor, "QR code or digital traceability not found where mandatory"));
      }
      if (RegExp(r'(sold on|amazon|flipkart|online)', caseSensitive: false).hasMatch(rawText)) {
        if (violations.any((v) => v.rule.id.startsWith("6."))) {
          violations.add(_createViolation("21.2", "E-Commerce Disclosure Missing", RuleCategory.labelFormat, Severity.major, "E-commerce mandatory disclosure incomplete"));
        }
      }
    } else {
      skippedByYear += 2;
    }

    // 2026 Test Rule
    if (manufacturingYear >= 2026) {
      applied += 1;
      violations.add(_createViolation("26.1", "2026 Future Rule", RuleCategory.categorySpecific, Severity.minor, "Test rule for 2026"));
    } else {
      skippedByYear += 1;
    }

    // DEDUPLICATE VIOLATIONS
    final uniqueViolations = <String, Violation>{};
    for (var v in violations) {
      uniqueViolations[v.rule.id] = v;
    }
    violations = uniqueViolations.values.toList();

    // PENALTY CALCULATION
    int totalUncapped = 0;
    for (var v in violations) {
      totalUncapped += v.penaltyAmount;
    }
    
    int cappedPenalty = min(totalUncapped, PenaltySchedule.firstOffenceCap);
    
    String penaltyExposure = "None";
    if (totalUncapped > 0) {
      if (totalUncapped > PenaltySchedule.firstOffenceCap && !isRepeatOffence) {
        penaltyExposure = "₹${PenaltySchedule.firstOffenceCap} (capped from ₹$totalUncapped)";
      } else {
        penaltyExposure = "₹$totalUncapped total exposure (within first-offence limit)";
      }
    }

    // Risk score uses UNCAPPED exposure per user instructions
    int riskScore = min(100, ((totalUncapped / PenaltySchedule.firstOffenceCap) * 100).round());
    
    // New Bands: 0–39 Low, 40–74 Medium, 75–100 High
    String riskLevel = "COMPLIANT";
    if (violations.isNotEmpty) {
      if (riskScore >= 75) {
        riskLevel = "HIGH RISK";
      } else if (riskScore >= 40) {
        riskLevel = "MEDIUM RISK";
      } else {
        riskLevel = "LOW RISK";
      }
    }
    
    print('CHECKIT: violations=${violations.length}, penalty=$totalUncapped (capped=$cappedPenalty), riskScore=$riskScore band=$riskLevel');

    return InspectionResult(
      productName: extractedProductName,
      manufacturingYear: manufacturingYear,
      violations: violations,
      passedRules: [],
      notApplicableRules: [],
      manualChecks: [],
      riskLevel: riskLevel,
      penaltyExposure: penaltyExposure,
      scannedAt: DateTime.now(),
      riskScore: riskScore,
      totalPenalty: cappedPenalty.toDouble(),
      isRepeatOffence: isRepeatOffence,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static Violation _createViolation(String id, String title, RuleCategory category, Severity severity, String evidence) {
    return Violation(
      rule: Rule(
        id: id,
        title: title,
        description: evidence,
        category: category,
        severity: severity,
        effectiveFromYear: 2011,
        isAutoDetectable: true,
        guidance: "",
      ),
      evidence: evidence,
      suggestion: PenaltySchedule.getCitation(category),
      severity: severity,
      penaltyAmount: PenaltySchedule.getPenalty(category, severity),
    );
  }
}


