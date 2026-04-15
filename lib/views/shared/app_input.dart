import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// プロトタイプのInコンポーネント再現
class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    this.controller,
    this.placeholder,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.showBorder = false,
    this.focusNode,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final int? maxLength;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final bool showBorder;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      textAlign: textAlign,
      maxLength: maxLength,
      onChanged: onChanged,
      style: GoogleFonts.zenKakuGothicNew(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: AppColors.text,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.zenKakuGothicNew(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: AppColors.textDisabled,
        ),
        filled: true,
        fillColor: AppColors.bgWarm,
        counterText: '',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: showBorder
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: showBorder
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: showBorder
              ? const BorderSide(color: AppColors.borderAccent)
              : BorderSide.none,
        ),
      ),
    );
  }
}
