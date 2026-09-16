import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final bool isPass;
  final String text;

  const StatusBadge({
    super.key,
    required this.isPass,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPass ? AppColors.successLight : AppColors.dangerLight, // 10% opacity is built-in to the Light colors
        borderRadius: BorderRadius.circular(9999), // Full pill shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPass ? Icons.check_circle : Icons.cancel,
            color: isPass ? AppColors.success : AppColors.danger,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isPass ? AppColors.success : AppColors.danger,
              fontWeight: FontWeight.w700, // 100% opacity bold text
            ),
          ),
        ],
      ),
    );
  }
}
