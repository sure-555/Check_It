import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StitchTheme {
  static const Color primary = Color(0xFF1C1917);
  static const Color primaryContainer = Color(0xFFE7E5E4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF1C1917);
  
  static const Color secondary = Color(0xFF059669);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFECFDF5);
  static const Color onSecondaryContainer = Color(0xFF064E3B);
  
  static const Color background = Color(0xFFFAFAF9);
  static const Color onBackground = Color(0xFF1C1917);
  
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1917);
  static const Color surfaceVariant = Color(0xFFF5F5F4);
  static const Color onSurfaceVariant = Color(0xFF78716C);
  
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFAFAF9);
  static const Color surfaceContainer = Color(0xFFF5F5F4);
  static const Color surfaceContainerHigh = Color(0xFFE7E5E4);
  static const Color surfaceContainerHighest = Color(0xFFD6D3D1);
  
  static const Color outline = Color(0xFFA8A29E);
  static const Color outlineVariant = Color(0xFFE7E5E4);
  
  static const Color error = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF991B1B);
  
  // Custom Status Colors
  static const Color complianceGreen = Color(0xFF059669);
  static const Color complianceAmber = Color(0xFFD97706);
  static const Color complianceRed = Color(0xFFDC2626);
  static const Color softMint = Color(0xFFECFDF5);
  static const Color forestEmerald = Color(0xFF064E3B);
  
  static const Color statusGreenDim = Color(0x26059669); // rgba(5, 150, 105, 0.15)
  static const Color statusGreen = Color(0xFF059669);

  // Typography
  static TextStyle displayLg = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    letterSpacing: -0.02 * 28,
  );

  static TextStyle titleLg = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  static TextStyle titleMd = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  static TextStyle titleSm = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
  );

  static TextStyle headlineMd = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: -0.01 * 20,
  );
  
  static TextStyle headlineSm = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static TextStyle headlineSmMobile = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
  );

  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20 / 13,
  );

  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );

  static TextStyle labelLg = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
  );

  static TextStyle labelMd = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 16 / 11,
    letterSpacing: 0.05 * 11,
  );

  static TextStyle labelSm = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 14 / 11,
  );
}
