import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_button.dart';

/// Premium準備中モーダル（プロトタイプのshowPremModal再現）
class PremiumComingSoonModal extends StatelessWidget {
  const PremiumComingSoonModal({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: const Color(0x662C2520),
      builder: (_) => const PremiumComingSoonModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '\u2726', // ✦
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'Premiumで追加できます',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '大切な人を3人以上登録するには\nPremiumプランが必要です。',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '近日公開予定',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              AppButton.secondary(
                onPressed: () => Navigator.of(context).pop(),
                label: '閉じる',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
