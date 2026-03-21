import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// プロトタイプのBtコンポーネント再現
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.primary = false,
    this.expand = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool primary;
  final bool expand;

  factory AppButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required String label,
  }) {
    return AppButton(
      key: key,
      onPressed: onPressed,
      primary: true,
      child: Text(label),
    );
  }

  factory AppButton.secondary({
    Key? key,
    required VoidCallback? onPressed,
    required String label,
  }) {
    return AppButton(
      key: key,
      onPressed: onPressed,
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? AppColors.accent : AppColors.bgWarm,
          foregroundColor: primary ? Colors.white : AppColors.textSecondary,
          elevation: 0,
          shadowColor: primary ? const Color(0x33B8784E) : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.zenKakuGothicNew(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: child,
      ),
    );
  }
}
