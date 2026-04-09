import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/important_person.dart';
import '../../providers/isar_provider.dart';
import '../../providers/user_settings_provider.dart';
import '../../services/life_calculator.dart';
import '../../services/notification_service.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_button.dart';
import '../shared/app_input.dart';
import '../shared/count_up_text.dart';
import 'welcome_page.dart';
import 'birth_input_page.dart';

/// オンボーディング全体フロー
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

enum _Screen { welcome, birth, steps }

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  _Screen _screen = _Screen.welcome;
  int _step = 0;
  DateTime? _birthDate;
  Gender _gender = Gender.unspecified;
  final _goalController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  void _goToBirth() => setState(() => _screen = _Screen.birth);

  void _goToSteps(DateTime birthDate, Gender gender) {
    setState(() {
      _birthDate = birthDate;
      _gender = gender;
      _screen = _Screen.steps;
      _step = 0;
    });
    ref
        .read(userSettingsProvider.notifier)
        .setBirthDateAndGender(birthDate, gender);
  }

  void _nextStep() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _complete();
    }
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _complete() async {
    // オンボーディングのゴールをIsarに保存
    if (_goalController.text.isNotEmpty) {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final record = await repo.getOrCreate(DateTime.now());
      record.todayGoal = _goalController.text;
      await repo.save(record);
    }
    // 通知許可リクエスト
    await NotificationService.requestPermission();
    // 通知スケジュール
    if (_birthDate != null) {
      final q = _questions[DateTime.now().day % _questions.length];
      await NotificationService.scheduleMorningNotification(
        hour: 7,
        minute: 0,
        birthDate: _birthDate!,
        gender: _gender,
        questionText: q['t']!,
      );
    }
    await ref.read(userSettingsProvider.notifier).completeOnboarding();
  }

  static const _questions = [
    {'id': 'p1', 'c': 'P', 't': '今日、あなたを笑顔にしてくれそうなことは？'},
    {'id': 'e1', 'c': 'E', 't': '今日、時間を忘れるほど没頭したいことは？'},
    {'id': 'r1', 'c': 'R', 't': '今日、誰かに「ありがとう」を伝えるとしたら？'},
    {'id': 'm1', 'c': 'M', 't': '今日という日を、どんな意味のある1日にしたい？'},
    {'id': 'a1', 'c': 'A', 't': '今日、小さくても達成したいことは何？'},
  ];

  @override
  Widget build(BuildContext context) {
    switch (_screen) {
      case _Screen.welcome:
        return WelcomePage(onStart: _goToBirth);
      case _Screen.birth:
        return BirthInputPage(onNext: _goToSteps);
      case _Screen.steps:
        return _buildSteps();
    }
  }

  Widget _buildSteps() {
    final lifeDays = LifeCalculator.lifeDays(_birthDate!);
    final remainingDays =
        LifeCalculator.remainingDays(_birthDate!, _gender);

    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: _stepContent(lifeDays, remainingDays),
                  ),
                ),
              ),
              // ページインジケーター
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _step ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _step ? AppColors.accent : AppColors.bgSub,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              // ナビゲーションボタン
              Row(
                children: [
                  if (_step > 0) ...[
                    Expanded(
                      child:
                          AppButton.secondary(onPressed: _prevStep, label: '戻る'),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: AppButton.primary(
                      onPressed: _nextStep,
                      label: _step == 3 ? 'はじめる' : '次へ',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepContent(int lifeDays, int remainingDays) {
    switch (_step) {
      case 0:
        // Step 1: 人生○○日目（カウントアップ）
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'YOUR LIFE IN NUMBERS',
              style: GoogleFonts.zenKakuGothicNew(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 3.5,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'あなたの人生は今日で',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            CountUpText(
              target: lifeDays,
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '日目です',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      case 1:
        // Step 2: 残りの人生
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'あなたの残りの人生は',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            CountUpText(
              target: remainingDays,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 72,
                fontWeight: FontWeight.w300,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '日です',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'この日々を\nどう過ごしますか？',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        );
      case 2:
        // Step 3: たった一度きり
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('\u{1F932}', style: TextStyle(fontSize: 32)), // 🤲
            const SizedBox(height: 40),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'でも\n今日という日は\n人生で',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      height: 1.8,
                    ),
                  ),
                  TextSpan(
                    text: 'たった一度きり',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      height: 1.8,
                      color: AppColors.accent,
                    ),
                  ),
                  TextSpan(
                    text: 'です',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 3:
        // Step 4: 今日何をしますか + 入力
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '後悔のない毎日を\n',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      height: 1.8,
                    ),
                  ),
                  TextSpan(
                    text: '一緒に積み重ねて',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.8,
                      color: AppColors.accent,
                    ),
                  ),
                  TextSpan(
                    text: 'いきましょう',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              width: 40,
              height: 1,
              color: AppColors.accent.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 40),
            Text(
              '今日を素晴らしい一日にするために\n何をしますか？',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: _goalController,
              placeholder: '小さなことでOK',
              maxLength: 200,
              textAlign: TextAlign.center,
              showBorder: true,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
