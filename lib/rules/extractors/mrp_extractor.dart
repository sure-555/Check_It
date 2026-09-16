import '../rule_models.dart';

class MrpExtractor {
  static List<Violation> analyze(String text, List<Rule> applicableRules) {
    List<Violation> violations = [];
    String lowerText = text.toLowerCase();
    
    // MRP-01 and MRP-02
    Rule? mrpRule = applicableRules.where((r) => r.id == 'MRP-01').firstOrNull;
    Rule? dupMrpRule = applicableRules.where((r) => r.id == 'MRP-02').firstOrNull;

    // Use regex to find MRP patterns
    RegExp mrpKeywordsRegex = RegExp(r'(mrp|m\.r\.p|maximum retail price|rs\.?|₹|/\-)', caseSensitive: false);
    bool hasMrp = mrpKeywordsRegex.hasMatch(text);
    
    // To check duplicates, maybe we need the original regex
    RegExp mrpValuesRegex = RegExp(r'(?:mrp|rs\.?|₹)\s*[:\-]?\s*[\d,]+\.?\d*', caseSensitive: false);
    Iterable<RegExpMatch> valueMatches = mrpValuesRegex.allMatches(text);

    if (mrpRule != null) {
      if (!hasMrp) {
        violations.add(Violation(
          rule: mrpRule,
          evidence: "No MRP found in text",
          suggestion: "Ensure MRP is clearly printed on the label.",
          severity: mrpRule.severity,
          penaltyAmount: 10000,
        ));
      } else {
        bool hasTaxes = lowerText.contains('inclusive of all taxes') || lowerText.contains('including all taxes');
        if (!hasTaxes) {
          violations.add(Violation(
            rule: mrpRule,
            evidence: valueMatches.isNotEmpty ? (valueMatches.first.group(0) ?? "MRP value") : "MRP text",
            suggestion: "Add 'inclusive of all taxes' next to the MRP.",
            severity: Severity.minor, // User specifically asked for minor violation
            penaltyAmount: 2000,
          ));
        }
      }
    }

    if (dupMrpRule != null && valueMatches.length > 1) {
      // Check if the matched values are actually duplicate MRPs or just multiple Rs values.
      // For simplicity, we just check if it's more than 1.
      violations.add(Violation(
        rule: dupMrpRule,
        evidence: valueMatches.map((m) => m.group(0)).join(', '),
        suggestion: "Remove duplicate MRP declarations.",
        severity: dupMrpRule.severity,
        penaltyAmount: 5000,
      ));
    }

    return violations;
  }
}
