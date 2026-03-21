import 'package:flutter/material.dart';

/// カラーパレット（WCAG AA コントラスト比準拠）
class AppColors {
  AppColors._();

  // Background
  static const Color bg = Color(0xFFFDFBF7);
  static const Color bgWarm = Color(0xFFF8F3EB);
  static const Color bgSub = Color(0xFFF2EDE4);

  // Card
  static const Color card = Color(0xFFFFFFFF);

  // Accent (warm brown)
  static const Color accent = Color(0xFFB8784E);
  static const Color accentLight = Color(0xFFD4A574);
  static const Color accentSurface = Color(0x14B8784E);
  static const Color accentSurface2 = Color(0x26B8784E);

  // Text（コントラスト比改善）
  static const Color text = Color(0xFF2C2520);
  static const Color textSecondary = Color(0xFF4A4039); // 旧#5C534A → 濃く
  static const Color textMuted = Color(0xFF7A7068); // 旧#9C8F82 → 濃く
  static const Color textDisabled = Color(0xFFA89888); // 旧#C4B8AA → 濃く

  // Border
  static const Color border = Color(0x0F2C2520);
  static const Color borderAccent = Color(0x40B8784E);

  // Shadow
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A2C2520),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: Color(0x082C2520),
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];
}
