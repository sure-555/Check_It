import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../config/app_colors.dart';

class RuleExplanationSheet extends StatelessWidget {
  final Violation violation;

  const RuleExplanationSheet({super.key, required this.violation});

  static void show(BuildContext context, Violation violation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RuleExplanationSheet(violation: violation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            violation.ruleName,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Citation: ${violation.ruleCitation}',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          
          Text('Correct vs Wrong Example', style: textTheme.titleMedium),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildExampleCard(
                  context,
                  title: 'Wrong',
                  content: _getWrongExample(),
                  color: AppColors.dangerLight,
                  borderColor: AppColors.danger,
                  icon: Icons.cancel,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildExampleCard(
                  context,
                  title: 'Correct',
                  content: _getCorrectExample(),
                  color: AppColors.successLight,
                  borderColor: AppColors.success,
                  icon: Icons.check_circle,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          Text('Why this matters', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            _getWhyItMatters(),
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, {
    required String title,
    required String content,
    required Color color,
    required Color borderColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: borderColor, size: 24),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: borderColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  String _getWrongExample() {
    if (violation.ruleId.contains('MRP')) return 'MRP 50/-';
    if (violation.ruleId.contains('DATE')) return 'Pkd: 05/26';
    return 'Missing or incomplete information';
  }

  String _getCorrectExample() {
    if (violation.ruleId.contains('MRP')) return 'MRP Rs. 50.00 (inclusive of all taxes)';
    if (violation.ruleId.contains('DATE')) return 'Mfg Date: 05/2026';
    return 'Complete and formatted information as per rules';
  }

  String _getWhyItMatters() {
    return 'Clear and standardized labeling ensures consumers are fully informed about what they are purchasing, preventing fraud and protecting consumer rights under the Legal Metrology Act.';
  }
}
