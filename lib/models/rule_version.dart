class RuleVersion {
  final String ruleId;
  final int year;
  final String category;
  final String condition;
  final String expectedFormat;

  RuleVersion({
    required this.ruleId,
    required this.year,
    required this.category,
    required this.condition,
    required this.expectedFormat,
  });
}
