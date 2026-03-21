import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// タイポグラフィ（iOS HIG準拠の最小サイズ）
/// Body: Zen Kaku Gothic New / Display: Cormorant Garamond
class AppTextStyles {
  AppTextStyles._();

  // Display (Cormorant Garamond)
  static TextStyle get displayLarge => GoogleFonts.cormorantGaramond(
        fontSize: 80,
        fontWeight: FontWeight.w300,
        height: 1.0,
      );

  static TextStyle get displayMedium => GoogleFonts.cormorantGaramond(
        fontSize: 48,
        fontWeight: FontWeight.w300,
        height: 1.0,
      );

  static TextStyle get displaySmall => GoogleFonts.cormorantGaramond(
        fontSize: 32,
        fontWeight: FontWeight.w300,
      );

  static TextStyle get headlineLarge => GoogleFonts.cormorantGaramond(
        fontSize: 44,
        fontWeight: FontWeight.w300,
        height: 1.35,
      );

  static TextStyle get headlineMedium => GoogleFonts.cormorantGaramond(
        fontSize: 30,
        fontWeight: FontWeight.w300,
      );

  static TextStyle get headlineSmall => GoogleFonts.cormorantGaramond(
        fontSize: 24,
        fontWeight: FontWeight.w400,
      );

  // Counter (today tab)
  static TextStyle get counter => GoogleFonts.cormorantGaramond(
        fontSize: 76,
        fontWeight: FontWeight.w300,
        height: 1.0,
      );

  // Body (Zen Kaku Gothic New)
  static TextStyle get bodyLarge => GoogleFonts.zenKakuGothicNew(
        fontSize: 17, // iOS HIG body default
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.zenKakuGothicNew(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get bodySmall => GoogleFonts.zenKakuGothicNew(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get caption => GoogleFonts.zenKakuGothicNew(
        fontSize: 13, // 旧12 → 13
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // Labels（カード内ヘッダー等）
  static TextStyle get label => GoogleFonts.zenKakuGothicNew(
        fontSize: 12, // 旧10 → 12
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textMuted,
      );

  // Section headers (YOUR LIFE, RECORDS等)
  static TextStyle get labelUppercase => GoogleFonts.zenKakuGothicNew(
        fontSize: 12, // 旧10 → 12
        fontWeight: FontWeight.w600,
        letterSpacing: 3.0,
        color: AppColors.textMuted,
      );

  // Pill label (PERMA category)
  static TextStyle get pill => GoogleFonts.zenKakuGothicNew(
        fontSize: 11, // 旧9 → 11
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.accent,
      );

  // Tab label
  static TextStyle get tabLabel => GoogleFonts.zenKakuGothicNew(
        fontSize: 11, // 旧8 → 11
        fontWeight: FontWeight.w400,
      );

  static TextStyle get tabLabelActive => GoogleFonts.zenKakuGothicNew(
        fontSize: 11, // 旧8 → 11
        fontWeight: FontWeight.w600,
      );
}
