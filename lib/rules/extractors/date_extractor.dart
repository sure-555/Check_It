import '../rule_models.dart';
import '../penalty_schedule.dart';

class DateExtractor {
  static int extractMfgYear(String text) {
    // Basic extraction to find a year near "Manufactured" or "Mfg"
    RegExp yearRegex = RegExp(r'(?:mfg|manufactured|pkd|packed)\s*(?:date|on)?\s*[:\-]?\s*[\s\S]{0,20}?\b(20\d{2})\b', caseSensitive: false);
    var match = yearRegex.firstMatch(text);
    if (match != null && match.groupCount >= 1) {
      return int.tryParse(match.group(1) ?? '2011') ?? 2011;
    }
    // Fallback: search for any 20xx year
    RegExp anyYearRegex = RegExp(r'\b(20\d{2})\b');
    var matches = anyYearRegex.allMatches(text);
    if (matches.isNotEmpty) {
      return int.tryParse(matches.first.group(1) ?? '2011') ?? 2011;
    }
    return 2011; // Default
  }

  static List<Violation> analyze(String text, List<Rule> applicableRules) {
    List<Violation> violations = [];
    Rule? dateRule = applicableRules.where((r) => r.id == 'DATE-01').firstOrNull;

    if (dateRule == null) return violations;

    // Use regex to find dates in formats DD/MM/YYYY MM/YYYY MM-YYYY MMM YYYY
    RegExp mfgRegex = RegExp(r'(?:mfg|manufactured|pkd|packed)\s*(?:date|on)?\s*[:\-]?\s*(\d{1,2}[/\-]\d{2,4}|\d{2}[/\-]\d{4}|[a-zA-Z]{3}\s*\d{4})', caseSensitive: false);
    RegExp expRegex = RegExp(r'(?:exp|expiry|use by|best before)\s*(?:date)?\s*[:\-]?\s*([\w\s/\-]+)', caseSensitive: false);

    var mfgMatch = mfgRegex.firstMatch(text);
    var expMatch = expRegex.firstMatch(text);

    if (mfgMatch == null) {
      violations.add(Violation(
        rule: dateRule,
        evidence: "Missing manufacturing date",
        suggestion: "Ensure manufacturing date is clearly printed.",
        severity: dateRule.severity,
        penaltyAmount: PenaltySchedule.getPenalty(dateRule.category, dateRule.severity),
      ));
    }

    if (expMatch == null) {
      violations.add(Violation(
        rule: dateRule,
        evidence: "Missing expiry/best before date",
        suggestion: "Ensure expiry or best before date is clearly printed.",
        severity: dateRule.severity,
        penaltyAmount: PenaltySchedule.getPenalty(dateRule.category, dateRule.severity),
      ));
    }

    // Ideally parse and compare dates here if both exist, but string comparison is complex without knowing exact format.
    // Assuming simple validation passes if both are present for this demo.
    
    return violations;
  }
}
