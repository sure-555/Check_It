import '../rules/rule_models.dart';

class BatchInspection {
  final String id;
  final String shopName;
  final String location;
  final DateTime date;
  final List<InspectionResult> products;

  BatchInspection({
    required this.id,
    required this.shopName,
    required this.location,
    required this.date,
    required this.products,
  });

  int get totalProducts => products.length;
  int get totalViolations => products.fold(0, (s, p) => s + (p.violations?.length ?? 0));
  
  int get totalPenalty {
    int total = 0;
    for (var product in products) {
      if (product.penaltyExposure != null && product.penaltyExposure != 'None') {
        try {
          String penaltyStr = product.penaltyExposure.toString().replaceAll(RegExp(r'[^0-9]'), '');
          if (penaltyStr.isNotEmpty) {
            total += int.parse(penaltyStr);
          }
        } catch (e) {
          // ignore parsing errors
        }
      }
    }
    return total;
  }
  
  int get compliantCount => products.where((p) => (p.violations == null || p.violations!.isEmpty)).length;
}
