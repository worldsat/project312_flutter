import 'package:flutter/material.dart';

/// Nexus Habitat Futuristic Color Tokens - Obsidian Void & Neon Glow.
/// Conforms to DESIGN.md and cross-platform design specifications.
class AppColors {
  // Primary - Electric Cyan
  static const Color electricCyan = Color(0xFF00F2FE);
  static const Color electricCyanDark = Color(0xFF081018);
  static const Color electricCyanContainer = Color(0xFF003544);
  static const Color electricCyanContainerGlow = Color(0x3300F2FE);
  static const Color onElectricCyanContainer = Color(0xFF66F6FF);
  static const Color electricCyanFixedDim = Color(0xFF00DCE6);
  static const Color electricCyanFixed = Color(0xFF6FF6FF);

  // Secondary - Violet Aurora
  static const Color violetAurora = Color(0xFF8B5CF6);
  static const Color violetContainer = Color(0xFF2E1065);
  static const Color violetContainerVibrant = Color(0xFF7701D0);
  static const Color violetContainerGlow = Color(0x407701D0);
  static const Color onVioletContainer = Color(0xFFDCB7FF);
  static const Color violetFixedDim = Color(0xFFDCB8FF);

  // Tertiary - Eco Emerald
  static const Color ecoEmerald = Color(0xFF10B981);
  static const Color ecoEmeraldBright = Color(0xFF67F4B7);
  static const Color ecoEmeraldDim = Color(0xFF4EDEA3);
  static const Color ecoEmeraldContainer = Color(0x3310B981);
  static const Color onEcoEmerald = Color(0xFF003824);
  static const Color onEcoEmeraldContainer = Color(0xFF006E4B);

  // Surfaces & Obsidian Shades
  static const Color obsidianBackground = Color(0xFF0A0E18);
  static const Color surfaceObsidian = Color(0xFF0F131D);
  static const Color surfaceDim = Color(0xFF0F131D);
  static const Color surfaceBright = Color(0xFF353944);
  static const Color surfaceContainerLowest = Color(0xFF070A11);
  static const Color surfaceContainerLow = Color(0xFF171B26);
  static const Color surfaceContainer = Color(0xFF1C1F2A);
  static const Color surfaceContainerHigh = Color(0xFF1E2433);
  static const Color surfaceContainerHighest = Color(0xFF313540);

  // Text & Content Shades
  static const Color onSurfaceWhite = Color(0xFFE2E8F0);
  static const Color onSurfaceVariantSlate = Color(0xFF94A3B8);
  static const Color onBackgroundSlate50 = Color(0xFFF8FAFC);

  // Glass Borders & Rim Overlays
  static const Color glassBorderStart = Color(0x33FFFFFF); // 20% alpha white rim
  static const Color glassBorderEnd = Color(0x0DFFFFFF);   // 5% alpha white rim
  static const Color outlineGlass = Color(0x1FFFFFFF);     // 12% alpha white
  static const Color outlineVariantSlate = Color(0x66334155); // 40% alpha Slate 700

  // Status & Error
  static const Color alertCrimson = Color(0xFFF43F5E);
  static const Color alertContainer = Color(0xFF93000A);
}
