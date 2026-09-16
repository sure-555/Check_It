import '../rule_models.dart';

class ManufacturerExtractor {
  static List<Violation> analyze(String text, List<Rule> applicableRules) {
    List<Violation> violations = [];
    Rule? mfgRule = applicableRules.where((r) => r.id == 'MFG-01').firstOrNull;
    
    if (mfgRule == null) return violations;

    
    // Check for address / pincode
    RegExp pincodeRegex = RegExp(r'\b\d{6}\b');
    bool hasPincode = pincodeRegex.hasMatch(text);
    
    if (!hasPincode) {
      violations.add(Violation(
        rule: mfgRule,
        evidence: "No address with pincode found",
        suggestion: "Include complete address with 6-digit pincode and country/state.",
        severity: mfgRule.severity, // Major
        penaltyAmount: 25000,
      ));
    } else {
      // Address exists. Check if company name exists before it.
      // A simple heuristic: if we don't see "manufactured by", "marketed by", or "mfg", we might flag company name missing.
      // But user says: "If address exists but no company name is found (no word before the address like "XYZ Foods"), flag as 'Manufacturer name missing' with penalty ₹10,000, not 'No manufacturer declaration found'."
      RegExp mfgDeclarationRegex = RegExp(r'(manufactured by|marketed by|mfg by|packed by|imported by)\s*[:\-]?\s*([a-zA-Z0-9\s,&]+)', caseSensitive: false);
      var mfgMatch = mfgDeclarationRegex.firstMatch(text);

      if (mfgMatch == null) {
        violations.add(Violation(
          rule: mfgRule,
          evidence: "Manufacturer name missing",
          suggestion: "Add company name before the address.",
          severity: mfgRule.severity,
          penaltyAmount: 10000,
        ));
      }
    }

    // Check for FSSAI
    RegExp fssaiKeywordRegex = RegExp(r'(fssai|lic|lic no|licence)\s*[:\-]?\s*(?:no\.?)?\s*([a-zA-Z0-9]*)', caseSensitive: false);
    var fssaiKeywordMatch = fssaiKeywordRegex.firstMatch(text);
    
    if (fssaiKeywordMatch != null) {
      // Find any number near it
      
      RegExp anyNumRegex = RegExp(r'(?:fssai|lic|lic no|licence)\s*[:\-]?\s*(?:no\.?)?\s*[^0-9]*(\d+)', caseSensitive: false);
      var anyNumMatch = anyNumRegex.firstMatch(text);

      if (anyNumMatch != null) {
        String numStr = anyNumMatch.group(1) ?? "";
        if (numStr.length != 14 && numStr.length != 11 && numStr.isNotEmpty) {
          violations.add(Violation(
            rule: mfgRule,
            evidence: "Found length: ${numStr.length} ($numStr)",
            suggestion: "FSSAI license must be exactly 14 digits (or 11 for importers).",
            severity: Severity.critical, // High
            penaltyAmount: 25000,
          ));
        }
      }
    }

    return violations;
  }
}
