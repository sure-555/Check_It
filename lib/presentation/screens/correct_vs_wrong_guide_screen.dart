import 'package:flutter/material.dart';
import '../theme/stitch_theme.dart';

class CorrectVsWrongGuideScreen extends StatelessWidget {
  const CorrectVsWrongGuideScreen({super.key});

  final List<Map<String, String>> _guides = const [
    {
      'title': 'MRP Display',
      'correct': 'MRP ₹500.00 (inclusive of all taxes)',
      'wrong': 'Price: 500\n(Local taxes extra)',
    },
    {
      'title': 'Net Weight',
      'correct': 'Net Quantity: 500 g\nor\nNet Weight: 500 g',
      'wrong': 'Weight: 1 packet\nSize: Large',
    },
    {
      'title': 'Date Format',
      'correct': 'Mfd: 08/2026\nor\nPkd: Aug 2026',
      'wrong': 'Mfd: See bottom of pack\n(Without specific date)',
    },
    {
      'title': 'FSSAI Logo',
      'correct': 'FSSAI Logo with 14-digit License Number clearly visible',
      'wrong': 'FSSAI text written without logo or license number',
    },
    {
      'title': 'Ingredient List',
      'correct': 'Ingredients: Wheat Flour (50%), Sugar, Edible Vegetable Oil...',
      'wrong': 'Made with natural ingredients (No detailed list)',
    },
    {
      'title': 'Veg/Non-Veg Symbol',
      'correct': 'Prominent Green dot in a green square (for Veg)',
      'wrong': 'No symbol or symbol hidden under fold',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        backgroundColor: StitchTheme.surface,
        title: Text('Correct vs Wrong', style: StitchTheme.titleLg.copyWith(color: StitchTheme.primary)),
        iconTheme: IconThemeData(color: StitchTheme.primary),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _guides.length,
        itemBuilder: (context, index) {
          final item = _guides[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['title']!, style: StitchTheme.titleMd.copyWith(fontWeight: FontWeight.bold, color: StitchTheme.primary)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCard('CORRECT', item['correct']!, StitchTheme.complianceGreen, Icons.check_circle)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCard('WRONG', item['wrong']!, StitchTheme.error, Icons.cancel)),
                ],
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(String label, String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: StitchTheme.labelSm.copyWith(color: color, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 12),
          Text(text, style: StitchTheme.bodySm.copyWith(color: StitchTheme.onSurface)),
        ],
      ),
    );
  }
}
