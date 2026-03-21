import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// プロトタイプのPlコンポーネント再現
class PillLabel extends StatelessWidget {
  const PillLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: AppTextStyles.pill),
    );
  }
}
