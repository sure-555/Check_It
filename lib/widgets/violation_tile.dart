import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../config/app_colors.dart';
import '../config/constants.dart';
import 'custom_card.dart';
import 'rule_explanation_sheet.dart';

class ViolationTile extends StatefulWidget {
  final Violation violation;

  const ViolationTile({super.key, required this.violation});

  @override
  State<ViolationTile> createState() => _ViolationTileState();
}

class _ViolationTileState extends State<ViolationTile> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.violation.status == Constants.statusFail;
  }

  Color _getSeverityColor() {
    switch (widget.violation.severity) {
      case Constants.severityCritical:
        return AppColors.danger;
      case Constants.severityMajor:
        return AppColors.warning;
      case Constants.severityMinor:
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPass = widget.violation.status == Constants.statusPass;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CustomCard(
        padding: EdgeInsets.zero,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _isExpanded = expanded;
              });
            },
            leading: Icon(
              isPass ? Icons.check_circle : Icons.error,
              color: isPass ? AppColors.success : AppColors.danger,
            ),
            title: Text(
              widget.violation.ruleName,
              style: textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: [
                if (!isPass)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(right: 8, top: 4),
                    decoration: BoxDecoration(
                      color: _getSeverityColor().withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.violation.severity,
                      style: textTheme.bodySmall?.copyWith(
                        color: _getSeverityColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Confidence: ${(widget.violation.confidence * 100).toInt()}%',
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Description',
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.violation.description,
                      style: textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isPass) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Suggestion',
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.violation.suggestion,
                        style: textTheme.bodyMedium?.copyWith(color: AppColors.danger),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        icon: const Icon(Icons.menu_book, size: 18),
                        label: const Text('Why this matters'),
                        onPressed: () {
                          RuleExplanationSheet.show(context, widget.violation);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
