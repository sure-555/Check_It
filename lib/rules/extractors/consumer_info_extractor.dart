import '../rule_models.dart';
import '../penalty_schedule.dart';

class ConsumerInfoExtractor {
  static List<Violation> analyze(String text, List<Rule> applicableRules) {
    List<Violation> violations = [];
    Rule? consRule = applicableRules.where((r) => r.id == 'CONS-01').firstOrNull;
    
    if (consRule == null) return violations;

    // Email
    RegExp emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    var emailMatch = emailRegex.firstMatch(text);

    // Phone / Toll free
    RegExp phoneRegex = RegExp(r'(?:ph|phone|call|customer care|toll free)\s*[:\-]?\s*([0-9\-\s]{8,15})', caseSensitive: false);
    var phoneMatch = phoneRegex.firstMatch(text);

    if (emailMatch == null && phoneMatch == null) {
      violations.add(Violation(
        rule: consRule,
        evidence: "No contact info",
        suggestion: "Provide a valid email address or customer care phone number.",
        severity: consRule.severity,
        penaltyAmount: PenaltySchedule.getPenalty(consRule.category, consRule.severity),
      ));
    }

    // Ingredients
    RegExp ingredientsRegex = RegExp(r'(?:ingredients)\s*[:\-]?\s*(.+)', caseSensitive: false);
    var ingredientsMatch = ingredientsRegex.firstMatch(text);

    if (ingredientsMatch == null) {
       violations.add(Violation(
        rule: consRule,
        evidence: "No ingredients list",
        suggestion: "Add 'Ingredients:' followed by the list of ingredients.",
        severity: consRule.severity,
        penaltyAmount: PenaltySchedule.getPenalty(consRule.category, consRule.severity),
      ));
    }

    return violations;
  }
}
