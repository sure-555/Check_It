import '../config/constants.dart';
import '../models/violation.dart';
import '../models/product_label.dart';

class RulesEngine {
  
  ProductLabel extractProductInfo(String rawText) {
    return ProductLabel(
      rawText: rawText,
      extractedMrp: _extractByRegex(rawText, r'(Rs\.?|₹)\s*\d+(\.\d{1,2})?'),
      extractedMfgDate: _extractByRegex(rawText, r'\d{2}/\d{4}'),
      extractedNetQuantity: _extractByRegex(rawText, r'\d+\s*(g|kg|ml|l)'),
    );
  }

  String? _extractByRegex(String text, String pattern) {
    final regExp = RegExp(pattern, caseSensitive: false);
    final match = regExp.firstMatch(text);
    return match?.group(0);
  }

  List<Violation> analyzeText(String rawText, int targetYear) {
    List<Violation> violations = [];

    final applicableRules = Constants.initialRules.where((r) => r['year'] as int <= targetYear).toList();

    for (var ruleMap in applicableRules) {
      final pattern = ruleMap['expectedFormat'] as String;
      final regExp = RegExp(pattern, caseSensitive: false);
      
      final isPass = regExp.hasMatch(rawText);
      
      violations.add(
        Violation(
          ruleId: ruleMap['ruleId'] as String,
          ruleName: ruleMap['ruleName'] as String,
          severity: ruleMap['severity'] as String,
          status: isPass ? Constants.statusPass : Constants.statusFail,
          confidence: isPass ? 0.95 : 0.85,
          description: isPass ? 'Rule requirement met in the label.' : ruleMap['condition'] as String,
          suggestion: ruleMap['suggestion'] as String,
          ruleCitation: ruleMap['ruleCitation'] as String,
        )
      );
    }
    return violations;
  }
}
