import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/daily_record.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';
import '../shared/app_button.dart';
import '../shared/app_input.dart';
import '../shared/action_buttons.dart';

/// 記録詳細画面（閲覧 + 編集モード対応）
class RecordDetailPage extends StatefulWidget {
  const RecordDetailPage({
    super.key,
    required this.record,
    required this.onBack,
    required this.onDelete,
    required this.onSave,
  });

  final DailyRecord record;
  final VoidCallback onBack;
  final VoidCallback onDelete;
  final Future<void> Function(DailyRecord) onSave;

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  bool _editing = false;

  // v1.0.1 新フィールド
  late final TextEditingController _gratitudeCtrl;
  late final TextEditingController _tomorrowMsgCtrl;

  // 既存フィールド
  late final TextEditingController _goalCtrl;
  late final TextEditingController _goodCtrl;
  late final TextEditingController _whyCtrl;
  late final TextEditingController _tomorrowCtrl;
  late final TextEditingController _weeklyHighCtrl;
  late final TextEditingController _weeklyChangeCtrl;

  @override
  void initState() {
    super.initState();
    _gratitudeCtrl =
        TextEditingController(text: widget.record.gratitude ?? '');
    _tomorrowMsgCtrl =
        TextEditingController(text: widget.record.tomorrowMessage ?? '');
    _goalCtrl = TextEditingController(text: widget.record.todayGoal ?? '');
    _goodCtrl =
        TextEditingController(text: widget.record.reflectionGood ?? '');
    _whyCtrl =
        TextEditingController(text: widget.record.reflectionWhy ?? '');
    _tomorrowCtrl =
        TextEditingController(text: widget.record.reflectionTomorrow ?? '');
    _weeklyHighCtrl = TextEditingController(
        text: widget.record.weeklyReflectionHighlight ?? '');
    _weeklyChangeCtrl = TextEditingController(
        text: widget.record.weeklyReflectionChange ?? '');
  }

  @override
  void dispose() {
    _gratitudeCtrl.dispose();
    _tomorrowMsgCtrl.dispose();
    _goalCtrl.dispose();
    _goodCtrl.dispose();
    _whyCtrl.dispose();
    _tomorrowCtrl.dispose();
    _weeklyHighCtrl.dispose();
    _weeklyChangeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final r = widget.record;
    r.gratitude =
        _gratitudeCtrl.text.isNotEmpty ? _gratitudeCtrl.text : null;
    r.tomorrowMessage =
        _tomorrowMsgCtrl.text.isNotEmpty ? _tomorrowMsgCtrl.text : null;
    r.todayGoal = _goalCtrl.text.isNotEmpty ? _goalCtrl.text : null;
    r.reflectionGood = _goodCtrl.text.isNotEmpty ? _goodCtrl.text : null;
    r.reflectionWhy = _whyCtrl.text.isNotEmpty ? _whyCtrl.text : null;
    r.reflectionTomorrow =
        _tomorrowCtrl.text.isNotEmpty ? _tomorrowCtrl.text : null;
    r.weeklyReflectionHighlight =
        _weeklyHighCtrl.text.isNotEmpty ? _weeklyHighCtrl.text : null;
    r.weeklyReflectionChange =
        _weeklyChangeCtrl.text.isNotEmpty ? _weeklyChangeCtrl.text : null;
    await widget.onSave(r);
    setState(() => _editing = false);
  }

  bool get _hasContent =>
      widget.record.gratitude != null ||
      widget.record.todayGoal != null ||
      widget.record.reflectionGood != null ||
      widget.record.tomorrowMessage != null ||
      widget.record.reflectionWhy != null ||
      widget.record.reflectionTomorrow != null;

  @override
  Widget build(BuildContext context) {
    final d = widget.record.date;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onBack,
          child: Text(
            '\u2190 戻る',
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 13,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${d.month}月${d.day}日の記録',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 24),
        if (_hasContent || _editing) ...[
          if (_editing) ..._buildEditMode() else ..._buildViewMode(),
          const SizedBox(height: 16),
          if (_editing)
            Row(children: [
              Expanded(
                child: AppButton.secondary(
                  onPressed: () => setState(() => _editing = false),
                  label: 'キャンセル',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton.primary(onPressed: _save, label: '保存'),
              ),
            ])
          else
            ActionButtons(
              onEdit: () => setState(() => _editing = true),
              onDelete: () async {
                final confirmed = await showDeleteConfirmation(
                  context,
                  title: 'この日の記録を削除しますか？',
                );
                if (confirmed) widget.onDelete();
              },
            ),
        ] else
          AppCard(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Text('\u{1F4DD}', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 12),
                Text(
                  'この日の記録はありません',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _buildViewMode() {
    final widgets = <Widget>[];

    // 朝のカード（感謝 + 今日を素晴らしい一日に）
    final morningFields = <Widget>[];
    if (widget.record.gratitude != null) {
      morningFields.add(_viewField('感謝していること', widget.record.gratitude!));
    }
    if (widget.record.todayGoal != null) {
      if (morningFields.isNotEmpty) morningFields.add(const SizedBox(height: 20));
      morningFields.add(_viewField('今日を素晴らしい一日にするために', widget.record.todayGoal!));
    }
    if (morningFields.isNotEmpty) {
      widgets.add(AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: morningFields)));
    }

    // 夜のカード（嬉しかったこと + 明日の自分へ）
    final eveningFields = <Widget>[];
    if (widget.record.reflectionGood != null) {
      eveningFields.add(_viewField('嬉しかったこと', widget.record.reflectionGood!));
    }
    if (widget.record.tomorrowMessage != null) {
      if (eveningFields.isNotEmpty) eveningFields.add(const SizedBox(height: 20));
      eveningFields.add(_viewField('明日の自分へ', widget.record.tomorrowMessage!));
    }
    if (eveningFields.isNotEmpty) {
      if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 14));
      widgets.add(AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: eveningFields)));
    }

    // v1.0 旧フィールド（過去データがあれば1枚のカードにまとめて表示）
    final legacyFields = <Widget>[];
    if (widget.record.reflectionWhy != null) {
      legacyFields.add(_viewField('\u{1F4AD} なぜ？', widget.record.reflectionWhy!));
    }
    if (widget.record.reflectionTomorrow != null) {
      if (legacyFields.isNotEmpty) legacyFields.add(const SizedBox(height: 20));
      legacyFields.add(_viewField('\u2728 明日の楽しみ', widget.record.reflectionTomorrow!));
    }
    if (widget.record.weeklyReflectionHighlight != null) {
      if (legacyFields.isNotEmpty) legacyFields.add(const SizedBox(height: 20));
      legacyFields.add(_viewField('\u{1F4C5} 今週のハイライト', widget.record.weeklyReflectionHighlight!));
    }
    if (widget.record.weeklyReflectionChange != null) {
      if (legacyFields.isNotEmpty) legacyFields.add(const SizedBox(height: 20));
      legacyFields.add(_viewField('\u{1F504} 来週変えること', widget.record.weeklyReflectionChange!));
    }
    if (legacyFields.isNotEmpty) {
      if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 14));
      widgets.add(AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: legacyFields)));
    }

    return widgets;
  }

  List<Widget> _buildEditMode() {
    final hasLegacyWhy = widget.record.reflectionWhy != null;
    final hasLegacyTomorrow = widget.record.reflectionTomorrow != null;
    final hasLegacyWeekly = widget.record.weeklyReflectionHighlight != null ||
        widget.record.weeklyReflectionChange != null;

    final widgets = <Widget>[];

    // 朝のカード
    widgets.add(AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _editField('感謝していること', _gratitudeCtrl),
          const SizedBox(height: 20),
          _editField('今日を素晴らしい一日にするために', _goalCtrl),
        ],
      ),
    ));

    // 夜のカード
    widgets.add(const SizedBox(height: 14));
    widgets.add(AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _editField('嬉しかったこと', _goodCtrl),
          const SizedBox(height: 20),
          _editField('明日の自分へ', _tomorrowMsgCtrl),
        ],
      ),
    ));

    // 旧フィールド（過去データがある場合のみ）
    final legacyEdits = <Widget>[];
    if (hasLegacyWhy) {
      legacyEdits.add(_editField('\u{1F4AD} なぜ？', _whyCtrl));
    }
    if (hasLegacyTomorrow) {
      if (legacyEdits.isNotEmpty) legacyEdits.add(const SizedBox(height: 20));
      legacyEdits.add(_editField('\u2728 明日の楽しみ', _tomorrowCtrl));
    }
    if (hasLegacyWeekly) {
      if (legacyEdits.isNotEmpty) legacyEdits.add(const SizedBox(height: 20));
      legacyEdits.add(_editField('\u{1F4C5} 今週のハイライト', _weeklyHighCtrl));
      legacyEdits.add(const SizedBox(height: 20));
      legacyEdits.add(_editField('\u{1F504} 来週変えること', _weeklyChangeCtrl));
    }
    if (legacyEdits.isNotEmpty) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: legacyEdits)));
    }

    return widgets;
  }

  static Widget _viewField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.zenKakuGothicNew(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.zenKakuGothicNew(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  static Widget _editField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.zenKakuGothicNew(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        AppInput(controller: ctrl, maxLength: 200),
      ],
    );
  }
}
