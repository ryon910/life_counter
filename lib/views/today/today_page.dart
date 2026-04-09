import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import '../../providers/isar_provider.dart';
import '../../providers/user_settings_provider.dart';
import '../../services/life_calculator.dart';
import '../../utils/prefs_keys.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';
import '../shared/app_input.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  final _gratitudeController = TextEditingController();
  final _goalController = TextEditingController();
  final _goodController = TextEditingController();
  final _tomorrowMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodayRecord();
    _checkReviewTiming();
    _gratitudeController.addListener(_autoSave);
    _goalController.addListener(_autoSave);
    _goodController.addListener(_autoSave);
    _tomorrowMessageController.addListener(_autoSave);
  }

  /// レビュー依頼のタイミングをチェック
  Future<void> _checkReviewTiming() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final repo = ref.read(dailyRecordRepositoryProvider);

      // 前日に夜の記入があるか確認
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayRecord = await repo.getByDate(yesterday);
      final hasYesterdayEvening = yesterdayRecord?.reflectionGood != null ||
          yesterdayRecord?.tomorrowMessage != null;

      if (!hasYesterdayEvening) return;

      // 全レコードから夜の記入がある日数をカウント
      final allRecords = await repo.getAll();
      final eveningDays = allRecords
          .where((r) => r.reflectionGood != null || r.tomorrowMessage != null)
          .length;

      final alreadyDay2 = prefs.getBool(PrefsKeys.reviewRequestedDay2) ?? false;
      final alreadyDay7 = prefs.getBool(PrefsKeys.reviewRequestedDay7) ?? false;

      bool shouldRequest = false;

      // Day 2: 夜の記入が2日以上 & まだ表示していない
      if (eveningDays >= 2 && !alreadyDay2) {
        await prefs.setBool(PrefsKeys.reviewRequestedDay2, true);
        shouldRequest = true;
      }
      // Day 7: 夜の記入が7日以上 & まだ表示していない
      else if (eveningDays >= 7 && !alreadyDay7) {
        await prefs.setBool(PrefsKeys.reviewRequestedDay7, true);
        shouldRequest = true;
      }

      if (shouldRequest) {
        final inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          // 少し遅延させて、画面が落ち着いてから表示
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            await inAppReview.requestReview();
          }
        }
      }
    } catch (e) {
      debugPrint('Review check error: $e');
    }
  }

  Future<void> _loadTodayRecord() async {
    try {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final record = await repo.getOrCreate(DateTime.now());
      if (mounted) {
        setState(() {
          _gratitudeController.text = record.gratitude ?? '';
          _goalController.text = record.todayGoal ?? '';
          _goodController.text = record.reflectionGood ?? '';
          _tomorrowMessageController.text = record.tomorrowMessage ?? '';
        });
      }
    } catch (e) {
      debugPrint('Today record load error: $e');
    }
  }

  // デバウンス用タイマー
  int _saveTimer = 0;

  void _autoSave() {
    _saveTimer++;
    final currentTimer = _saveTimer;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (currentTimer == _saveTimer && mounted) {
        _saveAll();
      }
    });
  }

  Future<void> _saveAll() async {
    try {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final record = await repo.getOrCreate(DateTime.now());
      record.gratitude =
          _gratitudeController.text.isNotEmpty ? _gratitudeController.text : null;
      record.todayGoal =
          _goalController.text.isNotEmpty ? _goalController.text : null;
      record.reflectionGood =
          _goodController.text.isNotEmpty ? _goodController.text : null;
      record.tomorrowMessage = _tomorrowMessageController.text.isNotEmpty
          ? _tomorrowMessageController.text
          : null;
      await repo.save(record);
    } catch (e) {
      debugPrint('Auto save error: $e');
    }
  }

  @override
  void dispose() {
    _gratitudeController.removeListener(_autoSave);
    _goalController.removeListener(_autoSave);
    _goodController.removeListener(_autoSave);
    _tomorrowMessageController.removeListener(_autoSave);
    _gratitudeController.dispose();
    _goalController.dispose();
    _goodController.dispose();
    _tomorrowMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(userSettingsProvider);
    final birthDate = settings.birthDate;
    if (birthDate == null) {
      return const Center(child: Text('オンボーディングを完了してください'));
    }

    final lifeDays = LifeCalculator.lifeDays(birthDate);
    final formatter = NumberFormat('#,###', 'ja_JP');
    final now = DateTime.now();
    final dateStr =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 48, 20, 130),
        child: Column(
          children: [
            // ヘッダー: 日付 + 人生日数
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  Text('YOUR LIFE', style: AppTextStyles.labelUppercase),
                  const SizedBox(height: 14),
                  Text(formatter.format(lifeDays),
                      style: AppTextStyles.counter),
                  const SizedBox(height: 8),
                  Text('日目',
                      style: GoogleFonts.zenKakuGothicNew(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.5,
                          color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Text(dateStr,
                      style: GoogleFonts.zenKakuGothicNew(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.5,
                          color: AppColors.textMuted)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 朝の問いかけ（1枚のカード）
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _questionField(
                    'いま感謝していることは？',
                    _gratitudeController,
                    'ひとつでも、いくつでも',
                  ),
                  const SizedBox(height: 24),
                  _questionField(
                    '今日を素晴らしい一日にするために、何をする？',
                    _goalController,
                    '小さなことでOK',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 夜の問いかけ（1枚のカード）
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _questionField(
                    '今日、嬉しかったことは？',
                    _goodController,
                    'どんな小さなことでも',
                  ),
                  const SizedBox(height: 24),
                  _questionField(
                    '明日の自分に一言伝えるなら？',
                    _tomorrowMessageController,
                    '自由にどうぞ',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionField(
    String label,
    TextEditingController controller,
    String placeholder,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.zenKakuGothicNew(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.6)),
        const SizedBox(height: 12),
        AppInput(
          controller: controller,
          placeholder: placeholder,
          maxLength: 200,
        ),
      ],
    );
  }
}
