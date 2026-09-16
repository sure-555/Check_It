import 'package:label_guard/rules/rule_engine.dart';
import 'package:label_guard/data/demo_label_texts.dart';

void main() {
  print('--- 2023 RUN ---');
  var r1 = RuleEngine.analyze(blocks: [], rawText: DemoLabelTexts.medicineBottle, manufacturingYear: 2023);
  print('Violations:');
  for (var v in r1.violations) {
    print(' - ${v.rule.id}: ${v.rule.title}');
  }
  
  print('--- 2026 RUN ---');
  var r2 = RuleEngine.analyze(blocks: [], rawText: DemoLabelTexts.medicineBottle, manufacturingYear: 2026);
  print('Violations:');
  for (var v in r2.violations) {
    print(' - ${v.rule.id}: ${v.rule.title}');
  }
}
