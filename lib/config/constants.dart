class Constants {
  // Routes
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routeScan = '/scan';
  static const String routeAnalysis = '/analysis';
  static const String routeResult = '/result';
  static const String routeHistory = '/history';
  static const String routeDashboard = '/dashboard';
  static const String routeProfile = '/profile';

  // Rule Sets (LMPC)
  static const String lmpcRules2011 = 'LMPC_2011';
  static const String lmpcRules2015 = 'LMPC_2015';
  static const String lmpcRules2020 = 'LMPC_2020';

  // Severities
  static const String severityCritical = 'CRITICAL';
  static const String severityMajor = 'MAJOR';
  static const String severityMinor = 'MINOR';

  // Statuses
  static const String statusPass = 'PASS';
  static const String statusFail = 'FAIL';
  
  // Product Categories
  static const String catFood = 'Food';
  static const String catMedicine = 'Medicine';
  static const String catCosmetics = 'Cosmetics';
  static const String catElectronics = 'Electronics';
  static const String catOther = 'Other';

  // Hardcoded initial rules (Tier 1 requirement)
  static const List<Map<String, dynamic>> initialRules = [
    {
      'ruleId': 'LMPC_R6_MRP',
      'ruleName': 'Maximum Retail Price (MRP)',
      'year': 2011,
      'category': 'All',
      'condition': 'Must clearly state "MRP Rs. XX.XX (inclusive of all taxes)"',
      'expectedFormat': r'MRP\s*(Rs\.?|₹)\s*\d+(\.\d{1,2})?\s*\(inclusive of all taxes\)',
      'severity': severityCritical,
      'suggestion': 'Ensure the MRP is printed clearly with the text "(inclusive of all taxes)".',
      'ruleCitation': 'Rule 6(1)(e)',
    },
    {
      'ruleId': 'LMPC_R6_DATE',
      'ruleName': 'Month and Year of Manufacture',
      'year': 2011,
      'category': 'All',
      'condition': 'Must show Month and Year of Manufacture/Packaged',
      'expectedFormat': r'(Mfg|Pkd)\.?\s*Date\s*:\s*\d{2}/\d{4}',
      'severity': severityCritical,
      'suggestion': 'Provide the month and year of packaging in a clear format.',
      'ruleCitation': 'Rule 6(1)(d)',
    },
    {
      'ruleId': 'LMPC_R6_ADDRESS',
      'ruleName': 'Manufacturer Address',
      'year': 2011,
      'category': 'All',
      'condition': 'Must contain complete name and address of the manufacturer',
      'expectedFormat': r'(Manufactured by|Mfd by|Packed by)',
      'severity': severityMajor,
      'suggestion': 'Include the full address of the manufacturer or packer.',
      'ruleCitation': 'Rule 6(1)(a)',
    },
    {
      'ruleId': 'LMPC_R6_NET_QTY',
      'ruleName': 'Net Quantity',
      'year': 2011,
      'category': 'All',
      'condition': 'Must contain net quantity in standard units',
      'expectedFormat': r'Net\s*(Qty|Weight|Volume|Wt)\.?\s*:\s*\d+\s*(g|kg|ml|l)',
      'severity': severityCritical,
      'suggestion': 'Specify the net quantity using standard metric units.',
      'ruleCitation': 'Rule 6(1)(c)',
    },
    {
      'ruleId': 'LMPC_R6_CONSUMER_CARE',
      'ruleName': 'Consumer Care Details',
      'year': 2011,
      'category': 'All',
      'condition': 'Must contain contact details for consumer complaints',
      'expectedFormat': r'(Consumer Care|Customer Care|Feedback|Complaints)',
      'severity': severityMajor,
      'suggestion': 'Provide a phone number, email, and address for consumer feedback.',
      'ruleCitation': 'Rule 6(1)(g)',
    },
  ];
}
