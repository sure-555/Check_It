import 'package:flutter/material.dart';
import '../../services/label_recognition/label_type.dart';
import '../theme/stitch_theme.dart';

class FallbackLabelPicker extends StatelessWidget {
  const FallbackLabelPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1917), // StitchTheme.surface or similar background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Product not auto-identified',
              style: StitchTheme.headlineSm.copyWith(color: StitchTheme.onPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a demo product to continue, or enter details manually.',
              style: StitchTheme.bodyMd.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildOption(
              context, 
              title: 'Aloo Bhujiya', 
              icon: Icons.fastfood,
              onTap: () => Navigator.pop(context, LabelType.alooBhujiya),
            ),
            const SizedBox(height: 12),
            _buildOption(
              context, 
              title: 'Chicken Fillet', 
              icon: Icons.set_meal,
              onTap: () => Navigator.pop(context, LabelType.chickenFillet),
            ),
            const SizedBox(height: 12),
            _buildOption(
              context, 
              title: 'Medicine Bottle', 
              icon: Icons.medical_services,
              onTap: () => Navigator.pop(context, LabelType.medicineBottle),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, LabelType.unknown),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: StitchTheme.secondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Manual Entry',
                style: TextStyle(
                  color: StitchTheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: StitchTheme.surface.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: StitchTheme.onPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: StitchTheme.titleMd.copyWith(color: StitchTheme.onPrimary),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
