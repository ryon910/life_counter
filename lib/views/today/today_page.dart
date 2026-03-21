import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../providers/isar_provider.dart';
import '../../providers/user_settings_provider.dart';
import '../../services/life_calculator.dart';
import '../../services/question_selector.dart';
import '../shared/app_colors.dart';
import '../shared/app_toast.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';
import '../shared/app_segmented_control.dart';
import '../shared/app_button.dart';
import '../shared/app_input.dart';
import '../shared/pill_label.dart';
import 'great_person_card.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  bool _isNightMode = false;
  String? _savedGoal;
  final _goalController = TextEditingController();
  final _goodController = TextEditingController();
  final _whyController = TextEditingController();
  final _tomorrowController = TextEditingController();
  final _weeklyHighlightController = TextEditingController();
  final _weeklyChangeController = TextEditingController();
  bool _reflectionSaved = false;
  String? _yesterdayGood;
  Map<String, dynamic>? _todayQuestion;

  @override
  void initState() {
    super.initState();
    _initNightMode();
    _loadAll();
  }

  /// 設定時刻に基づいて夜モードを自動判定
  void _initNightMode() {
    final settings = ref.read(userSettingsProvider);
    final now = DateTime.now();
    final nightStart = DateTime(
        now.year, now.month, now.day,
        settings.nightModeHour, settings.nightModeMinute);
    _isNightMode = now.isAfter(nightStart);
  }

  /// 全データを並列で読み込み（エラーハンドリング付き）
  Future<void> _loadAll() async {
    await Future.wait([
      _loadTodayRecord(),
      _loadYesterdayReflection(),
      _loadQuestion(),
    ]);
  }

  Future<void> _loadQuestion() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final q = await QuestionSelector.selectToday(prefs);
      if (mounted) setState(() => _todayQuestion = q);
    } catch (e) {
      debugPrint('Question load error: $e');
    }
  }

  Future<void> _loadTodayRecord() async {
    try {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final record = await repo.getOrCreate(DateTime.now());
      if (mounted) {
        setState(() {
          if (record.todayGoal != null) _savedGoal = record.todayGoal;
          if (record.reflectionGood != null) {
            _goodController.text = record.reflectionGood!;
            _whyController.text = record.reflectionWhy ?? '';
            _tomorrowController.text = record.reflectionTomorrow ?? '';
            _reflectionSaved = true;
          }
        });
      }
    } catch (e) {
      debugPrint('Today record load error: $e');
    }
  }

  Future<void> _loadYesterdayReflection() async {
    try {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final record = await repo.getByDate(yesterday);
      if (mounted && record?.reflectionGood != null) {
        setState(() => _yesterdayGood = record!.reflectionGood);
      }
    } catch (e) {
      debugPrint('Yesterday reflection load error: $e');
    }
  }

  Future<void> _saveGoal(String goal) async {
    final repo = ref.read(dailyRecordRepositoryProvider);
    final record = await repo.getOrCreate(DateTime.now());
    record.todayGoal = goal;
    await repo.save(record);
    setState(() => _savedGoal = goal);
  }

  Future<void> _saveReflection() async {
    final repo = ref.read(dailyRecordRepositoryProvider);
    final record = await repo.getOrCreate(DateTime.now());
    record.reflectionGood =
        _goodController.text.isNotEmpty ? _goodController.text : null;
    record.reflectionWhy =
        _whyController.text.isNotEmpty ? _whyController.text : null;
    record.reflectionTomorrow =
        _tomorrowController.text.isNotEmpty ? _tomorrowController.text : null;
    if (_isSunday) {
      record.weeklyReflectionHighlight =
          _weeklyHighlightController.text.isNotEmpty
              ? _weeklyHighlightController.text
              : null;
      record.weeklyReflectionChange =
          _weeklyChangeController.text.isNotEmpty
              ? _weeklyChangeController.text
              : null;
    }
    await repo.save(record);
    setState(() => _reflectionSaved = true);
    if (mounted) AppToast.success(context, '保存しました');
  }

  @override
  void dispose() {
    _goalController.dispose();
    _goodController.dispose();
    _whyController.dispose();
    _tomorrowController.dispose();
    _weeklyHighlightController.dispose();
    _weeklyChangeController.dispose();
    super.dispose();
  }

  bool get _isSunday => DateTime.now().weekday == DateTime.sunday;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(userSettingsProvider);
    final birthDate = settings.birthDate;
    if (birthDate == null) {
      return const Center(child: Text('オンボーディングを完了してください'));
    }

    final lifeDays = LifeCalculator.lifeDays(birthDate);
    final userAge = LifeCalculator.currentAge(birthDate);
    final formatter = NumberFormat('#,###', 'ja_JP');

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 48, 20, 130),
        child: Column(
          children: [
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
                ],
              ),
            ),
            Center(
              child: AppSegmentedControl<bool>(
                items: const [
                  SegmentItem(value: false, label: '\u2600 朝'),
                  SegmentItem(value: true, label: '\u{1F319} 夜'),
                ],
                selectedValue: _isNightMode,
                onChanged: (v) => setState(() {
                  _isNightMode = v;
                  if (!v) _reflectionSaved = false;
                }),
              ),
            ),
            const SizedBox(height: 24),
            if (!_isNightMode)
              ..._buildMorning(userAge)
            else
              ..._buildEvening(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMorning(int userAge) {
    return [
      if (_todayQuestion != null) _questionCard(_todayQuestion!),
      const SizedBox(height: 14),
      _goalCard(),
      const SizedBox(height: 14),
      if (_yesterdayGood != null) ...[
        AppCard(
          color: AppColors.bgWarm,
          showShadow: false,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\u{1F33F} 昨日の振り返り',
                    style: AppTextStyles.label.copyWith(letterSpacing: 0)),
                const SizedBox(height: 10),
                Text('「$_yesterdayGood」',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
              ]),
        ),
        const SizedBox(height: 14),
      ],
      GreatPersonCard(userAge: userAge),
    ];
  }

  List<Widget> _buildEvening() {
    return [
      if (_todayQuestion != null) _questionCard(_todayQuestion!),
      const SizedBox(height: 14),
      if (_savedGoal != null) ...[
        AppCard(
          color: AppColors.bgWarm,
          showShadow: false,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\u270E 今日やること',
                    style: AppTextStyles.label.copyWith(letterSpacing: 0)),
                const SizedBox(height: 8),
                Text(_savedGoal!,
                    style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 14, fontWeight: FontWeight.w300)),
              ]),
        ),
        const SizedBox(height: 14),
      ],
      AppCard(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('\u{1F319} 夜の振り返り',
                  style: AppTextStyles.label.copyWith(letterSpacing: 0)),
              const SizedBox(height: 20),
              _reflectionField('今日、良かったことは？', _goodController),
              const SizedBox(height: 18),
              _reflectionField('それは、なぜ起きた？', _whyController),
              const SizedBox(height: 18),
              _reflectionField('明日、楽しみなことは？', _tomorrowController),
              if (_isSunday) ...[
                const SizedBox(height: 8),
                const Divider(color: AppColors.border),
                const SizedBox(height: 20),
                Text('\u{1F4C5} 週の振り返り（日曜日）',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.accent, letterSpacing: 0)),
                const SizedBox(height: 16),
                _reflectionField(
                    '今週、一番心に残った瞬間は？', _weeklyHighlightController),
                const SizedBox(height: 18),
                _reflectionField(
                    '来週、一つだけ変えるとしたら？', _weeklyChangeController),
              ],
              const SizedBox(height: 16),
              AppButton.primary(
                onPressed: _saveReflection,
                label: _reflectionSaved ? '更新する' : '記録する',
              ),
            ]),
      ),
    ];
  }

  Widget _questionCard(Map<String, dynamic> q) {
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          PillLabel(text: q['category'] as String),
          const SizedBox(width: 8),
          Text('今日の問い',
              style: AppTextStyles.label.copyWith(letterSpacing: 0)),
        ]),
        const SizedBox(height: 14),
        Text(q['text'] as String,
            style: GoogleFonts.zenKakuGothicNew(
                fontSize: 15, fontWeight: FontWeight.w300, height: 1.9)),
      ]),
    );
  }

  Widget _goalCard() {
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('\u270E 今日、何をする？',
            style: AppTextStyles.label.copyWith(letterSpacing: 0)),
        const SizedBox(height: 14),
        if (_savedGoal != null)
          Row(children: [
            Expanded(
                child: Text(_savedGoal!,
                    style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 15, fontWeight: FontWeight.w400))),
            GestureDetector(
              onTap: () => setState(() {
                _goalController.text = _savedGoal!;
                _savedGoal = null;
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.bgWarm,
                    borderRadius: BorderRadius.circular(8)),
                child: Text('編集',
                    style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 11, color: AppColors.textMuted)),
              ),
            ),
          ])
        else
          Row(children: [
            Expanded(
                child: AppInput(
                    controller: _goalController,
                    placeholder: '今日やりたいことを1つ',
                    maxLength: 100)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                if (_goalController.text.isNotEmpty) {
                  _saveGoal(_goalController.text);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10)),
                child: Text('保存',
                    style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ),
          ]),
      ]),
    );
  }

  Widget _reflectionField(String label, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12)),
      const SizedBox(height: 8),
      AppInput(controller: controller, maxLength: 100),
    ]);
  }
}
