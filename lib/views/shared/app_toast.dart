import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// 統一トースト表示
class AppToast {
  AppToast._();

  /// 成功トースト（保存、更新、削除完了等）
  static void success(BuildContext context, String message) {
    _show(context, message, AppColors.accent);
  }

  /// エラートースト（バリデーション、通信エラー等）
  static void error(BuildContext context, String message) {
    _show(context, message, const Color(0xFFC17A56));
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.zenKakuGothicNew(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
