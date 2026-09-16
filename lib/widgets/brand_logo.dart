import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  
  const BrandLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundColor: AppColors.primaryContainer,
        radius: size / 2,
        child: Icon(
          Icons.shield_outlined,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }
}
