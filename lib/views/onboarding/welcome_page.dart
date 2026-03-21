import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';

/// ウェルカム画面（プロトタイプの welcome 再現）
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.4),
            radius: 0.7,
            colors: [
              Color(0x14D4A574), // rgba(212,165,116,0.08)
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LIFE COUNTER',
                  style: AppTextStyles.labelUppercase,
                ),
                const SizedBox(height: 40),
                // グラデーション丸
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.accentLight, AppColors.accent],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // タイトル
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '人生は\n',
                        style: AppTextStyles.headlineLarge,
                      ),
                      TextSpan(
                        text: '有限',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'だから',
                        style: AppTextStyles.headlineLarge,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  '今日が人生の何日目か\n知っていますか\n\n残りの日々を意識することで\n毎日をもっと大切に過ごせるように',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 2.0,
                  ),
                ),
                const SizedBox(height: 56),
                // はじめるボタン
                ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 56, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                    shadowColor: const Color(0x40B8784E),
                    textStyle: GoogleFonts.zenKakuGothicNew(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  child: const Text('はじめる'),
                ),
                const SizedBox(height: 56),
                // 下矢印アニメーション
                const _BreathingArrow(),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BreathingArrow extends StatefulWidget {
  const _BreathingArrow();

  @override
  State<_BreathingArrow> createState() => _BreathingArrowState();
}

class _BreathingArrowState extends State<_BreathingArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 0.8).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.textDisabled,
        size: 24,
      ),
    );
  }
}
