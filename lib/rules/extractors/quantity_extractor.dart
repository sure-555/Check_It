import '../rule_models.dart';
import '../penalty_schedule.dart';

class QuantityExtractor {
  static List<Violation> analyze(String text, List<Rule> applicableRules) {
    List<Violation> violations = [];
    Rule? qtyRule = applicableRules.where((r) => r.id == 'QTY-01').firstOrNull;
    
    if (qtyRule == null) return violations;

    // Regex for net weight / net quantity
    RegExp qtyRegex = RegExp(r'(net\s*(?:wt|weight|qty|quantity)?)\s*[:\-]?\s*\d+(?:\.\d+)?\s*([a-zA-Z]+)', caseSensitive: false);
    var match = qtyRegex.firstMatch(text);

    if (match == null) {
      violations.add(Violation(
        rule: qtyRule,
        evidence: "No net quantity declaration found",
        suggestion: "Add net quantity in metric units (e.g., Net Wt: 500g).",
        severity: qtyRule.severity,
        penaltyAmount: PenaltySchedule.getPenalty(qtyRule.category, qtyRule.severity),
      ));
    } else {
      String unit = match.group(2) ?? "";
      List<String> validUnits = ['g', 'kg', 'ml', 'l'];
      List<String> invalidVariants = ['gm', 'g.', 'kgs', 'pound', 'oz', 'lb'];
      
      if (!validUnits.contains(unit) || invalidVariants.contains(unit.toLowerCase())) {
        violations.add(Violation(
          rule: qtyRule,
          evidence: match.group(0) ?? "",
          suggestion: "Change unit '$unit' to standard metric (g, kg, ml, L).",
          severity: qtyRule.severity,
          penaltyAmount: PenaltySchedule.getPenalty(qtyRule.category, qtyRule.severity),
        ));
      } else if (unit != unit.toLowerCase() && unit != 'L') {
        // Must be lowercase except L
        violations.add(Violation(
          rule: qtyRule,
          evidence: match.group(0) ?? "",
          suggestion: "Use lowercase metric unit (e.g., '$unit' should be '${unit.toLowerCase()}').",
          severity: qtyRule.severity,
          penaltyAmount: PenaltySchedule.getPenalty(qtyRule.category, qtyRule.severity),
        ));
      }
    }

    return violations;
  }
}
