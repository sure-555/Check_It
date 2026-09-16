import 'package:flutter/material.dart';
import '../theme/stitch_theme.dart';

class ComplianceRulebookScreen extends StatefulWidget {
  const ComplianceRulebookScreen({super.key});

  @override
  State<ComplianceRulebookScreen> createState() => _ComplianceRulebookScreenState();
}

class _ComplianceRulebookScreenState extends State<ComplianceRulebookScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All', 'MRP', 'Quantity', 'Manufacturer', 'Dates', 'Consumer Info', 'Label Format'
  ];

  final List<Map<String, dynamic>> _rules = [
    {
      'id': 'LM(PC) Rule 6(1)(e)',
      'title': 'Declaration of MRP',
      'short': 'Maximum Retail Price must be declared inclusive of all taxes.',
      'category': 'MRP',
      'penalty': '₹5,000 to ₹100,000',
      'severity': 'Critical',
      'full_text': 'Every package shall bear thereon or on a label securely affixed thereto a definite, plain and conspicuous declaration as to the retail sale price of the package. The MRP shall be printed as "Maximum Retail Price Rs/₹... (inclusive of all taxes)".',
      'example': 'Violation: "Price ₹500 (Local taxes extra)" is illegal. Correct: "MRP ₹500 (inclusive of all taxes)"'
    },
    {
      'id': 'LM(PC) Rule 6(1)(a)',
      'title': 'Name & Address of Manufacturer',
      'short': 'Must display name and complete address of the manufacturer or packer.',
      'category': 'Manufacturer',
      'penalty': '₹25,000',
      'severity': 'Major',
      'full_text': 'Every package shall bear the name and complete address of the manufacturer, or where the manufacturer is not the packer, the name and address of the manufacturer and packer, or importer.',
      'example': 'Violation: Only "Manufactured in India" without address. Correct: "Manufactured by XYZ Pvt Ltd, 123 Industrial Area, Mumbai 400001"'
    },
    {
      'id': 'LM(PC) Rule 6(1)(b)',
      'title': 'Common or Generic Name',
      'short': 'Must state the common or generic name of the commodity.',
      'category': 'Label Format',
      'penalty': '₹10,000',
      'severity': 'Minor',
      'full_text': 'The common or generic names of the commodity contained in the package and in case of packages with more than one product, the name and number or quantity of each product shall be mentioned.',
      'example': 'Violation: A box just labeled "Snacks". Correct: "Potato Chips - 50g, Namkeen - 50g"'
    },
    {
      'id': 'LM(PC) Rule 6(1)(c)',
      'title': 'Net Quantity',
      'short': 'Net quantity in standard unit of weight or measure.',
      'category': 'Quantity',
      'penalty': '₹25,000',
      'severity': 'Critical',
      'full_text': 'The net quantity, in terms of the standard unit of weight or measure, of the commodity contained in the package or where the commodity is packed or sold by number, the number of the commodity contained in the package shall be mentioned.',
      'example': 'Violation: "Weight: 1 packet". Correct: "Net Quantity: 500 g"'
    },
    {
      'id': 'LM(PC) Rule 6(1)(d)',
      'title': 'Month and Year of Manufacture',
      'short': 'Must state month and year of manufacture or pre-packing.',
      'category': 'Dates',
      'penalty': '₹15,000',
      'severity': 'Major',
      'full_text': 'The month and year in which the commodity is manufactured or pre-packed or imported shall be mentioned on the package.',
      'example': 'Violation: Missing manufacturing date. Correct: "Mfd: 08/2026"'
    },
    {
      'id': 'LM(PC) Rule 6(1)(f)',
      'title': 'Consumer Care Details',
      'short': 'Contact details for consumer complaints.',
      'category': 'Consumer Info',
      'penalty': '₹20,000',
      'severity': 'Major',
      'full_text': 'Where any packaging material bearing the declaration required by these rules has been used for packaging, the name, address, telephone number, and e-mail address of the person who can be or the office which can be, contacted, in case of consumer complaints.',
      'example': 'Violation: No customer care number. Correct: "For feedback contact Customer Care Executive at 1800-XXX-XXXX or email at help@company.com"'
    },
    {
      'id': 'LM(PC) Rule 7',
      'title': 'Principal Display Panel',
      'short': 'All information must be grouped together and given in one place.',
      'category': 'Label Format',
      'penalty': '₹5,000',
      'severity': 'Minor',
      'full_text': 'All declarations required to be made under these rules shall be given on the principal display panel.',
      'example': 'Violation: MRP on top, Weight on bottom, address on the side. Correct: Grouped together in one visible area.'
    },
    {
      'id': 'LM(PC) Rule 18(1)',
      'title': 'Wholesale Package Declaration',
      'short': 'Wholesale packages have specific declaration requirements.',
      'category': 'Label Format',
      'penalty': '₹10,000',
      'severity': 'Major',
      'full_text': 'Every wholesale package shall bear thereon a legible, definite, plain and conspicuous declaration as to the name and address of the manufacturer/importer/packer, the identity of the commodity, and the total number of retail packages contained in such wholesale package.',
      'example': 'Violation: Master carton without piece count. Correct: "Contains 50 retail units of 100g each"'
    },
    {
      'id': 'LM(PC) Rule 9(1)',
      'title': 'Manner of Declaration',
      'short': 'Declarations must be legible and prominent.',
      'category': 'Label Format',
      'penalty': '₹5,000',
      'severity': 'Minor',
      'full_text': 'Every declaration which is required to be made on a package under these rules shall be legible and prominent, definite, plain and conspicuous as to the nature, quantity and other details.',
      'example': 'Violation: MRP printed in 2mm font size hidden under a flap. Correct: Clearly printed in contrasting color.'
    },
    {
      'id': 'LM(PC) Rule 18(8)',
      'title': 'Bar Code/E-Commerce',
      'short': 'E-commerce platforms must display mandatory declarations.',
      'category': 'Label Format',
      'penalty': '₹100,000',
      'severity': 'Critical',
      'full_text': 'An E-commerce entity shall ensure that the mandatory declarations as specified in rule 6, except the month and year in which the commodity is manufactured or packed, shall be displayed on the digital and electronic network used for e-commerce transactions.',
      'example': 'Violation: Product listing without MRP or Manufacturer details. Correct: Full label info in product description.'
    },
    {
      'id': 'LM(PC) Rule 13',
      'title': 'Standard Units of Measure',
      'short': 'Must use standard SI units.',
      'category': 'Quantity',
      'penalty': '₹10,000',
      'severity': 'Major',
      'full_text': 'The declaration of quantity shall be expressed in terms of such units of weight, measure or number as are standard under the Act.',
      'example': 'Violation: "Weight: 1 Pound". Correct: "Weight: 454g"'
    },
    {
      'id': 'LM(PC) Rule 2(h)',
      'title': 'Non-Standard Packages',
      'short': 'Packing in non-standard quantities where standard is mandated.',
      'category': 'Quantity',
      'penalty': '₹25,000',
      'severity': 'Critical',
      'full_text': 'Certain commodities must be packed in specified standard quantities as per Schedule II.',
      'example': 'Violation: Packing tea in 65g when standard sizes are 50g, 100g. Correct: Pack in 50g or 100g.'
    },
    {
      'id': 'LM(PC) Rule 32',
      'title': 'Smudging/Altering MRP',
      'short': 'Tampering with the MRP is illegal.',
      'category': 'MRP',
      'penalty': '₹25,000',
      'severity': 'Critical',
      'full_text': 'No person shall alter, smudge or obliterate the declaration of retail sale price on the package.',
      'example': 'Violation: Putting a sticker of ₹150 over printed MRP ₹100. Correct: Sell at or below printed MRP.'
    },
    {
      'id': 'LM(PC) Rule 10',
      'title': 'Size of Letters/Numerals',
      'short': 'Minimum font size depends on package area.',
      'category': 'Label Format',
      'penalty': '₹10,000',
      'severity': 'Major',
      'full_text': 'The height of any numeral and letter in the declaration required under these rules shall not be less than as specified in Table I based on the principal display panel area.',
      'example': 'Violation: 1mm font on a 200 sq cm panel. Correct: Use minimum 2mm font for standard packages.'
    },
    {
      'id': 'LM(PC) Rule 12',
      'title': 'Multi-Piece Packages',
      'short': 'Special declarations for multi-piece packs.',
      'category': 'Quantity',
      'penalty': '₹10,000',
      'severity': 'Minor',
      'full_text': 'A multi-piece package shall bear a declaration of the number of individual pieces contained therein and the MRP of the whole package and also the MRP of individual pieces.',
      'example': 'Violation: No individual piece count. Correct: "Contains 10 bars of 20g each. Total Net Weight 200g"'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRules = _rules.where((r) {
      final matchesSearch = r['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            r['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' || r['category'] == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        backgroundColor: StitchTheme.surface,
        title: Text('Compliance Rulebook', style: StitchTheme.titleLg.copyWith(color: StitchTheme.primary)),
        iconTheme: IconThemeData(color: StitchTheme.primary),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search rules...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: StitchTheme.surfaceContainerLowest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((f) {
                final isSelected = _selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedFilter = f),
                    backgroundColor: StitchTheme.surfaceContainerLowest,
                    selectedColor: StitchTheme.primary.withValues(alpha: 0.1),
                    checkmarkColor: StitchTheme.primary,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredRules.length,
              itemBuilder: (context, index) {
                final rule = filteredRules[index];
                return _buildRuleCard(rule);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(Map<String, dynamic> rule) {
    Color severityColor;
    switch (rule['severity']) {
      case 'Critical': severityColor = StitchTheme.error; break;
      case 'Major': severityColor = Colors.orange; break;
      default: severityColor = StitchTheme.complianceGreen;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: StitchTheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(rule['id'], style: StitchTheme.bodySm.copyWith(color: StitchTheme.primary, fontWeight: FontWeight.bold)),
          subtitle: Text(rule['title'], style: StitchTheme.bodyMd.copyWith(fontWeight: FontWeight.w600, color: StitchTheme.onSurface)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(rule['severity'], style: StitchTheme.labelSm.copyWith(color: severityColor, fontWeight: FontWeight.bold)),
          ),
          childrenPadding: const EdgeInsets.all(16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rule['full_text'], style: StitchTheme.bodySm.copyWith(color: StitchTheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: StitchTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gavel, size: 16, color: StitchTheme.outline),
                      const SizedBox(width: 8),
                      Text('Penalty: ${rule['penalty']}', style: StitchTheme.labelMd.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(rule['example'], style: StitchTheme.bodySm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
