import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? accentColor; // For 4px left-accent border

  const CustomCard({
    super.key, 
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: const BorderSide(color: AppColors.border, width: 1),
          right: const BorderSide(color: AppColors.border, width: 1),
          bottom: const BorderSide(color: AppColors.border, width: 1),
          left: BorderSide(
            color: accentColor ?? AppColors.border, 
            width: accentColor != null ? 4 : 1
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}
