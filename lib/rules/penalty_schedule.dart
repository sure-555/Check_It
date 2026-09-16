import 'rule_models.dart';

class PenaltySchedule {
  /// Section 36(1) of the Legal Metrology Act, 2009 prescribes a fine up to ₹25,000 for the first offence.
  static const int firstOffenceCap = 25000;

  /// Default per-violation penalties for the demo. 
  /// The sum of these is capped at firstOffenceCap.
  static int getPenalty(RuleCategory category, Severity severity) {
    switch (severity) {
      case Severity.critical:
        return 5000; // source: default critical violation penalty
      case Severity.major:
        return 2500; // source: default major violation penalty
      case Severity.minor:
        return 1000; // source: default minor violation penalty
      default:
        return 0;
    }
  }

  /// Official citation chain
  static String getCitation(RuleCategory category) {
    // All Rule 6 declaration failures fall under Section 18, penalized by Section 36(1).
    return "LMPC Rule 6(1), 2011 ← Sec 18(1) LM Act 2009 ← Penalty: Sec 36(1)";
  }
}
