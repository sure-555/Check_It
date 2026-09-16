import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Indigo Emerald Governance)
  static const Color primary = Color(0xFF182537); // Indigo Slate
  static const Color primaryContainer = Color(0xFF2E3B4E); // Indigo Slate container
  static const Color secondary = Color(0xFF516072);
  static const Color secondaryContainer = Color(0xFFD2E1F7);
  static const Color tertiary = Color(0xFF002B1F);
  static const Color tertiaryContainer = Color(0xFF004332);
  
  // Aliases from DESIGN.md
  static const Color indigoSlate = Color(0xFF2E3B4E);
  static const Color forestEmerald = Color(0xFF064E3B);
  static const Color silverGray = Color(0xFF94A3B8);
  static const Color softMint = Color(0xFFECFDF5);
  
  // Background & Surfaces
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Color(0xFFF7F9FB);
  static const Color cardSurface = Color(0xFFFFFFFF);
  
  // Semantic Colors
  static const Color success = Color(0xFF059669);
  static const Color complianceGreen = Color(0xFF059669);
  static const Color successLight = Color(0xFFECFDF5);
  
  static const Color warning = Color(0xFFD97706);
  static const Color complianceAmber = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  
  static const Color danger = Color(0xFFDC2626);
  static const Color complianceRed = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFFEE2E2);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF191C1E); // on-surface
  static const Color textSecondary = Color(0xFF44474C); // on-surface-variant
  static const Color textMuted = Color(0xFF75777D); // outline
  
  // Border
  static const Color border = Color(0xFFE2E8F0); // 1px Slate tone
  
  // Shadows (Surface Level 2: 0px 10px 25px rgba(46, 59, 78, 0.08))
  static const Color shadowColor = Color(0x142E3B4E); // 0.08 opacity (14 hex)
  static const Color shadowColorHeavy = Color(0x292E3B4E); // 0.16 opacity
  
  // Legacy compatibility aliases (keep them so existing code doesn't break if not refactored yet)
  static const Color primaryLight = Color(0xFFE2E8F0); 
}
