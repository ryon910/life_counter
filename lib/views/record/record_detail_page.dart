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
  late final TextEditingController _goalCtrl;
  late final TextEditingController _goodCtrl;
  late final TextEditingController _whyCtrl;
  late final TextEditingController _tomorrowCtrl;
  late final TextEditingController _weeklyHighCtrl;
  late final TextEditingController _weeklyChangeCtrl;

  @override
  void initState() {
    super.initState();
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
    return [
      if (widget.record.todayGoal != null)
        _viewCard('\u270E 今日やること', widget.record.todayGoal!),
      if (widget.record.reflectionGood != null) ...[
        const SizedBox(height: 12),
        _viewCard('\u{1F33F} 良かったこと', widget.record.reflectionGood!),
      ],
      if (widget.record.reflectionWhy != null) ...[
        const SizedBox(height: 12),
        _viewCard('\u{1F4AD} なぜ？', widget.record.reflectionWhy!),
      ],
      if (widget.record.reflectionTomorrow != null) ...[
        const SizedBox(height: 12),
        _viewCard('\u2728 明日の楽しみ', widget.record.reflectionTomorrow!),
      ],
      if (widget.record.weeklyReflectionHighlight != null) ...[
        const SizedBox(height: 12),
        _viewCard(
            '\u{1F4C5} 今週のハイライト', widget.record.weeklyReflectionHighlight!),
      ],
      if (widget.record.weeklyReflectionChange != null) ...[
        const SizedBox(height: 12),
        _viewCard(
            '\u{1F504} 来週変えること', widget.record.weeklyReflectionChange!),
      ],
    ];
  }

  List<Widget> _buildEditMode() {
    final hasWeekly = widget.record.weeklyReflectionHighlight != null ||
        widget.record.weeklyReflectionChange != null;
    return [
      _editField('\u270E 今日やること', _goalCtrl),
      const SizedBox(height: 12),
      _editField('\u{1F33F} 良かったこと', _goodCtrl),
      const SizedBox(height: 12),
      _editField('\u{1F4AD} なぜ？', _whyCtrl),
      const SizedBox(height: 12),
      _editField('\u2728 明日の楽しみ', _tomorrowCtrl),
      if (hasWeekly) ...[
        const SizedBox(height: 12),
        _editField('\u{1F4C5} 今週のハイライト', _weeklyHighCtrl),
        const SizedBox(height: 12),
        _editField('\u{1F504} 来週変えること', _weeklyChangeCtrl),
      ],
    ];
  }

  bool get _hasContent =>
      widget.record.todayGoal != null ||
      widget.record.reflectionGood != null ||
      widget.record.reflectionWhy != null ||
      widget.record.reflectionTomorrow != null;

  static Widget _viewCard(String label, String value) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.label.copyWith(letterSpacing: 0)),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _editField(String label, TextEditingController ctrl) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.label.copyWith(letterSpacing: 0)),
          const SizedBox(height: 10),
          AppInput(controller: ctrl, maxLength: 100),
        ],
      ),
    );
  }

}
