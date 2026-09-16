import '../rules/rule_models.dart';
import '../services/label_recognition/label_type.dart';

class DummyLabelReports {
  static InspectionResult getReportByType(LabelType type) {
    switch (type) {
      case LabelType.alooBhujiya: 
        return _alooBhujiyaReport();
      case LabelType.chickenFillet: 
        return _chickenFilletReport();
      case LabelType.medicineBottle: 
        return _medicineBottleReport();
      case LabelType.unknown: 
        return _alooBhujiyaReport(); // fallback
    }
  }

  static InspectionResult _alooBhujiyaReport() => InspectionResult(
    productName: 'Aloo Bhujiya',
    manufacturingYear: 2023,
    riskLevel: 'MEDIUM RISK',
    riskScore: 58,
    penaltyExposure: '₹25000 (capped from ₹27000)',
    violations: [
      Violation(
        rule: Rule(id: 'LMPC-6-1-a', title: 'Manufacturer/Packer Declaration', description: 'Label shows "Barcode Label Guru" (label printer) instead of actual manufacturer name and address.', category: RuleCategory.manufacturer, severity: Severity.critical, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Barcode Label Guru"\n"Address Line 1. MG Road, Vadodara, Gujarat-390020."',
        suggestion: 'Replace with actual manufacturer name and complete address.',
        severity: Severity.critical,
        penaltyAmount: 5000,
      ),
      Violation(
        rule: Rule(id: 'FSSAI-14DIGIT', title: 'FSSAI License Number Format', description: 'FSSAI license number is 10 digits (0123456790). Must be exactly 14 digits.', category: RuleCategory.consumerInfo, severity: Severity.critical, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"FSSAI No. : 0123456790"',
        suggestion: 'Obtain valid 14-digit FSSAI manufacturing license.',
        severity: Severity.critical,
        penaltyAmount: 8000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-c', title: 'Date of Manufacture/Packing', description: '"When Packed" field contains garbled data "1 0 0 0 1" instead of valid date.', category: RuleCategory.date, severity: Severity.critical, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"When Packed : 1 0 0 0 1"',
        suggestion: 'Print actual packing date in DD/MM/YYYY format.',
        severity: Severity.critical,
        penaltyAmount: 5000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-a-MISLEADING', title: 'Misleading Third-Party Information', description: 'Label printer contact details appear on consumer-facing label, misleading consumers.', category: RuleCategory.consumerInfo, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Barcode Label Guru"\n"softwareketan@gmail.com"',
        suggestion: 'Remove all printer/vendor information.',
        severity: Severity.major,
        penaltyAmount: 5000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-d-TERMINOLOGY', title: 'Net Quantity Terminology', description: 'Uses "Net Weight" instead of "Net Quantity". Uses informal "Gm." instead of "g".', category: RuleCategory.quantity, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Net Weight : 250 Gm."',
        suggestion: 'Use "Net Quantity: 250 g".',
        severity: Severity.major,
        penaltyAmount: 4000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-e-BBFORMAT', title: 'Best Before Date Reference', description: '"Best Before : 90 Days" does not specify reference date.', category: RuleCategory.date, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Best Before : 90 Days"',
        suggestion: 'State "90 Days from date of Packing" or absolute calendar date.',
        severity: Severity.major,
        penaltyAmount: 4000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-g', title: 'Consumer Care Details', description: 'No consumer care for actual manufacturer. Only printer contact shown.', category: RuleCategory.consumerInfo, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Contact : 9727955514 softwareketan@gmail.com"',
        suggestion: 'Provide manufacturer toll-free number/email.',
        severity: Severity.major,
        penaltyAmount: 5000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-h-ACCURACY', title: 'Declaration Accuracy', description: 'Spelling errors: "Comodities", inconsistent spacing.', category: RuleCategory.labelFormat, severity: Severity.minor, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Packed Comodities, Rules 2011"',
        suggestion: 'Proofread compliance declarations.',
        severity: Severity.minor,
        penaltyAmount: 2000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-i', title: 'Country of Origin', description: 'Country of origin not declared.', category: RuleCategory.consumerInfo, severity: Severity.minor, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'Not found',
        suggestion: 'Add "Country of Origin: India".',
        severity: Severity.minor,
        penaltyAmount: 1000,
      ),
    ],
    passedRules: [],
    notApplicableRules: [],
    manualChecks: [],
    scannedAt: DateTime.now(),
    latitude: 22.3072,
    longitude: 73.1812,
  );

  static InspectionResult _chickenFilletReport() => InspectionResult(
    productName: 'Fresh Chicken Breast Boneless Fillet',
    manufacturingYear: 2020,
    riskLevel: 'MEDIUM RISK',
    riskScore: 44,
    penaltyExposure: '₹12000 total exposure (within first-offence limit)',
    violations: [
      Violation(
        rule: Rule(id: 'LMPC-6-1-d-TERMINOLOGY', title: 'Net Quantity Terminology', description: 'Uses "Net Content" instead of "Net Quantity". Uses "GM" instead of "g".', category: RuleCategory.quantity, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Net Content 500 GM"',
        suggestion: 'Use "Net Quantity: 500 g".',
        severity: Severity.major,
        penaltyAmount: 2500,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-f-MRPWORDING', title: 'MRP Tax Declaration Wording', description: '"incl all Taxes" is informal. Should use "inclusive of all taxes".', category: RuleCategory.mrp, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"MRP Rs. 190.00 incl all Taxes"',
        suggestion: 'Use standard wording "inclusive of all taxes".',
        severity: Severity.major,
        penaltyAmount: 3500,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-j', title: 'Storage Conditions Specification', description: '"Keep in 4 degree Temp" lacks unit. For perishable poultry, precise temperature is critical.', category: RuleCategory.categorySpecific, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Keep in 4 degree Temp"',
        suggestion: 'Use "Store at 4 degrees C" or "Keep Refrigerated at 0-4 degrees C".',
        severity: Severity.major,
        penaltyAmount: 3500,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-e-PERISHABLE', title: 'Use By Date for Highly Perishable Goods', description: 'Fresh chicken uses "Best Before" instead of mandatory "Use By".', category: RuleCategory.date, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Best Before from Packed Date 4 Days"',
        suggestion: 'Replace with "Use By: [absolute calendar date]" for fresh meat.',
        severity: Severity.major,
        penaltyAmount: 5000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-e-BBFORMAT', title: 'Date Reference Clarity', description: '"4 Days" without explicit "from date of packing" reference.', category: RuleCategory.date, severity: Severity.minor, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: '"Best Before from Packed Date 4 Days"',
        suggestion: 'Use absolute calendar date.',
        severity: Severity.minor,
        penaltyAmount: 2000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-i', title: 'Country of Origin', description: 'Country of origin not declared.', category: RuleCategory.consumerInfo, severity: Severity.minor, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'Not found',
        suggestion: 'Add "Country of Origin: India".',
        severity: Severity.minor,
        penaltyAmount: 1000,
      ),
    ],
    passedRules: [],
    notApplicableRules: [],
    manualChecks: [],
    scannedAt: DateTime.now(),
    latitude: 22.3072,
    longitude: 73.1812,
  );

  static InspectionResult _medicineBottleReport() => InspectionResult(
    productName: 'Unidentified Pharmaceutical Product',
    manufacturingYear: 2023,
    riskLevel: 'HIGH RISK',
    riskScore: 94,
    penaltyExposure: '₹25000 (capped from ₹28500)',
    violations: [
      Violation(
        rule: Rule(id: 'LMPC-6-1-a-NAME', title: 'Product Name Declaration', description: 'Product name completely missing. Consumers cannot identify the medicine.', category: RuleCategory.labelFormat, severity: Severity.critical, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'No product name found',
        suggestion: 'Print generic and brand name prominently.',
        severity: Severity.critical,
        penaltyAmount: 5000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-a-MFG', title: 'Manufacturer/Packer Name & Address', description: 'No manufacturer name or address. No way to trace product liability.', category: RuleCategory.manufacturer, severity: Severity.critical, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'No manufacturer information found',
        suggestion: 'Add full manufacturer name and address.',
        severity: Severity.critical,
        penaltyAmount: 10000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-d', title: 'Net Quantity Declaration', description: 'Net quantity not declared. Cannot compare value or verify dosage supply.', category: RuleCategory.quantity, severity: Severity.critical, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'No net quantity found',
        suggestion: 'Add "Net Quantity: 60 tablets" or "100 mL".',
        severity: Severity.critical,
        penaltyAmount: 8000,
      ),
      Violation(
        rule: Rule(id: 'DRUGS-ACT-LICENSE', title: 'Drug Manufacturing License Number', description: 'No drug manufacturing license number. Mandatory under Drugs and Cosmetics Act.', category: RuleCategory.categorySpecific, severity: Severity.critical, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'No license number found',
        suggestion: 'Print valid manufacturing license and GMP certification.',
        severity: Severity.critical,
        penaltyAmount: 8000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-g', title: 'Consumer Care Contact', description: 'No phone/email for consumer complaints or adverse event reporting.', category: RuleCategory.consumerInfo, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'No consumer care details found',
        suggestion: 'Add toll-free number and email for pharmacovigilance.',
        severity: Severity.major,
        penaltyAmount: 5000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-j', title: 'Storage Conditions', description: 'No storage instructions. Medicines require specific conditions.', category: RuleCategory.categorySpecific, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'No storage conditions found',
        suggestion: 'Add "Store in a cool, dry place" or specific temperature.',
        severity: Severity.major,
        penaltyAmount: 4000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-b', title: 'Contents/Composition Declaration', description: 'Active ingredients not listed. Cannot check allergies or drug interactions.', category: RuleCategory.categorySpecific, severity: Severity.major, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'No composition found',
        suggestion: 'List all active ingredients with strengths.',
        severity: Severity.major,
        penaltyAmount: 4000,
      ),
      Violation(
        rule: Rule(id: 'LMPC-6-1-i', title: 'Country of Origin', description: 'Country of origin not declared.', category: RuleCategory.consumerInfo, severity: Severity.minor, effectiveFromYear: 2011, isAutoDetectable: true, guidance: ''),
        evidence: 'Not found',
        suggestion: 'Add "Made in India".',
        severity: Severity.minor,
        penaltyAmount: 1000,
      ),
    ],
    passedRules: [],
    notApplicableRules: [],
    manualChecks: [],
    scannedAt: DateTime.now(),
    latitude: 22.3072,
    longitude: 73.1812,
  );
}
