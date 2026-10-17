import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// AppTheme: Theme configuration for Nexus Habitat Flutter app conforming to DESIGN.md.
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.surfaceObsidian,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.electricCyan,
        onPrimary: AppColors.electricCyanDark,
        primaryContainer: AppColors.electricCyanContainer,
        onPrimaryContainer: AppColors.onElectricCyanContainer,
        secondary: AppColors.violetAurora,
        onSecondary: Colors.black,
        secondaryContainer: AppColors.violetContainer,
        onSecondaryContainer: AppColors.onVioletContainer,
        tertiary: AppColors.ecoEmerald,
        onTertiary: AppColors.onEcoEmerald,
        tertiaryContainer: AppColors.ecoEmeraldContainer,
        onTertiaryContainer: AppColors.onEcoEmeraldContainer,
        error: AppColors.alertCrimson,
        onError: Colors.white,
        errorContainer: AppColors.alertContainer,
        onErrorContainer: Colors.white,
        surface: AppColors.surfaceObsidian,
        onSurface: AppColors.onBackgroundSlate50,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        onSurfaceVariant: AppColors.onSurfaceVariantSlate,
        outline: AppColors.outlineGlass,
        outlineVariant: AppColors.outlineVariantSlate,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: AppColors.onBackgroundSlate50,
          letterSpacing: -0.03 * 56,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackgroundSlate50,
          letterSpacing: -0.02 * 32,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackgroundSlate50,
          letterSpacing: -0.01 * 24,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackgroundSlate50,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackgroundSlate50,
          letterSpacing: 0.01 * 16,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onBackgroundSlate50,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariantSlate,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariantSlate,
          letterSpacing: 0.01 * 12,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackgroundSlate50,
          letterSpacing: 0.02 * 14,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariantSlate,
          letterSpacing: 0.04 * 12,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariantSlate,
          letterSpacing: 0.06 * 10,
        ),
      ),
    );
  }
}
