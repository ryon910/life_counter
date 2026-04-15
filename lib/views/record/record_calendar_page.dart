import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/daily_record.dart';
import '../../providers/isar_provider.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';
import '../shared/app_input.dart';
import '../shared/app_segmented_control.dart';

/// 記録タブ（プロトタイプの RecordsTab 再現）
class RecordCalendarPage extends ConsumerStatefulWidget {
  const RecordCalendarPage({super.key});

  @override
  RecordCalendarPageState createState() => RecordCalendarPageState();
}

enum _RecordView { calendar, list }

class RecordCalendarPageState extends ConsumerState<RecordCalendarPage> {
  _RecordView _view = _RecordView.list;
  DateTime _focusedDay = DateTime.now();
  DailyRecord? _selectedRecord;
  List<DailyRecord> _records = [];
  int? _editingRecordId;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  /// 外部からデータ再読み込みを呼び出す
  void reload() => _loadRecords();

  Future<void> _loadRecords() async {
    final repo = ref.read(dailyRecordRepositoryProvider);
    final records = await repo.getAll();
    if (mounted) setState(() => _records = records);
  }

  Set<DateTime> get _recordDates {
    return _records
        .where((r) => _hasContent(r))
        .map((r) => DateTime(r.date.year, r.date.month, r.date.day))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 48, 20, 130),
        child: Column(
          children: [
            Text('RECORDS', style: AppTextStyles.labelUppercase),
            const SizedBox(height: 24),
            Center(
              child: AppSegmentedControl<_RecordView>(
                items: const [
                  SegmentItem(value: _RecordView.list, label: 'リスト'),
                  SegmentItem(value: _RecordView.calendar, label: 'カレンダー'),
                ],
                selectedValue: _view,
                onChanged: (v) => setState(() => _view = v),
              ),
            ),
            const SizedBox(height: 24),
            if (_view == _RecordView.calendar) ...[
              _buildCalendar(),
              if (_selectedRecord != null) ...[
                const SizedBox(height: 16),
                _buildSelectedRecordCard(),
              ],
            ] else
              _buildList(),
          ],
        ),
      ),
    );
  }

  /// カレンダーで選択した日の記録カード（インライン表示）
  Widget _buildSelectedRecordCard() {
    final r = _selectedRecord!;
    final isEditing = _editingRecordId == r.id;

    if (isEditing) {
      return _InlineEditCard(
        record: r,
        onSave: (updated) async {
          final repo = ref.read(dailyRecordRepositoryProvider);
          await repo.save(updated);
          setState(() {
            _editingRecordId = null;
            _selectedRecord = updated;
          });
          _loadRecords();
        },
        onCancel: () => setState(() => _editingRecordId = null),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(r.date),
                style: GoogleFonts.zenKakuGothicNew(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _editingRecordId = r.id),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.textDisabled,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._buildInlineFields(r),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return AppCard(
      child: TableCalendar(
        firstDay: DateTime(2020),
        lastDay: DateTime.now(),
        focusedDay: _focusedDay,
        locale: 'ja_JP',
        startingDayOfWeek: StartingDayOfWeek.sunday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.zenKakuGothicNew(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: AppColors.accentSurface2,
            shape: BoxShape.circle,
          ),
          todayTextStyle: GoogleFonts.zenKakuGothicNew(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
          defaultTextStyle: GoogleFonts.zenKakuGothicNew(
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
          weekendTextStyle: GoogleFonts.zenKakuGothicNew(
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          markerSize: 5,
          markersMaxCount: 1,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.zenKakuGothicNew(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textDisabled,
          ),
          weekendStyle: GoogleFonts.zenKakuGothicNew(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textDisabled,
          ),
        ),
        eventLoader: (day) {
          final normalized = DateTime(day.year, day.month, day.day);
          return _recordDates.contains(normalized) ? [true] : [];
        },
        onDaySelected: (selected, focused) async {
          final repo = ref.read(dailyRecordRepositoryProvider);
          final record = await repo.getOrCreate(selected);
          if (mounted) {
            setState(() {
              _selectedRecord = record;
              _editingRecordId = null;
            });
          }
        },
        onPageChanged: (focused) => _focusedDay = focused,
      ),
    );
  }

  bool _hasContent(DailyRecord r) {
    return r.gratitude != null ||
        r.todayGoal != null ||
        r.reflectionGood != null ||
        r.tomorrowMessage != null ||
        r.reflectionWhy != null ||
        r.reflectionTomorrow != null ||
        r.weeklyReflectionHighlight != null ||
        r.weeklyReflectionChange != null;
  }

  Widget _buildList() {
    final filtered = _records.where((r) => _hasContent(r)).toList();
    if (filtered.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Text('\u{1F4DD}', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            Text(
              '記録はまだありません',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }
    return Column(
      children: filtered.map((r) {
        final isEditing = _editingRecordId == r.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: isEditing
              ? _InlineEditCard(
                  record: r,
                  onSave: (updated) async {
                    final repo = ref.read(dailyRecordRepositoryProvider);
                    await repo.save(updated);
                    setState(() => _editingRecordId = null);
                    _loadRecords();
                  },
                  onCancel: () => setState(() => _editingRecordId = null),
                )
              : AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(r.date),
                            style: GoogleFonts.zenKakuGothicNew(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _editingRecordId = r.id),
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._buildInlineFields(r),
                    ],
                  ),
                ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final weekday = DateFormat.E('ja_JP').format(date);
    return '${date.month}/${date.day} ($weekday)';
  }

  List<Widget> _buildInlineFields(DailyRecord r) {
    final fields = <(String, String)>[];
    if (r.gratitude != null) fields.add(('感謝していること', r.gratitude!));
    if (r.todayGoal != null) fields.add(('今日やること', r.todayGoal!));
    if (r.reflectionGood != null) fields.add(('嬉しかったこと', r.reflectionGood!));
    if (r.tomorrowMessage != null) fields.add(('明日の自分へ', r.tomorrowMessage!));
    if (r.reflectionWhy != null) fields.add(('なぜ？', r.reflectionWhy!));
    if (r.reflectionTomorrow != null) fields.add(('明日の楽しみ', r.reflectionTomorrow!));
    if (r.weeklyReflectionHighlight != null) fields.add(('今週のハイライト', r.weeklyReflectionHighlight!));
    if (r.weeklyReflectionChange != null) fields.add(('来週変えること', r.weeklyReflectionChange!));

    if (fields.isEmpty) {
      return [
        Text(
          '(未入力)',
          style: GoogleFonts.zenKakuGothicNew(
            fontSize: 12,
            color: AppColors.textDisabled,
            fontWeight: FontWeight.w300,
          ),
        ),
      ];
    }

    return fields.asMap().entries.map((entry) {
      final isLast = entry.key == fields.length - 1;
      return Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.value.$1,
              style: GoogleFonts.zenKakuGothicNew(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              entry.value.$2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.zenKakuGothicNew(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

/// カード内インライン編集ウィジェット
class _InlineEditCard extends StatefulWidget {
  const _InlineEditCard({
    required this.record,
    required this.onSave,
    required this.onCancel,
  });

  final DailyRecord record;
  final Future<void> Function(DailyRecord) onSave;
  final VoidCallback onCancel;

  @override
  State<_InlineEditCard> createState() => _InlineEditCardState();
}

class _InlineEditCardState extends State<_InlineEditCard> {
  late final TextEditingController _gratitudeCtrl;
  late final TextEditingController _goalCtrl;
  late final TextEditingController _goodCtrl;
  late final TextEditingController _tomorrowMsgCtrl;

  @override
  void initState() {
    super.initState();
    _gratitudeCtrl = TextEditingController(text: widget.record.gratitude ?? '');
    _goalCtrl = TextEditingController(text: widget.record.todayGoal ?? '');
    _goodCtrl = TextEditingController(text: widget.record.reflectionGood ?? '');
    _tomorrowMsgCtrl = TextEditingController(text: widget.record.tomorrowMessage ?? '');
  }

  @override
  void dispose() {
    _gratitudeCtrl.dispose();
    _goalCtrl.dispose();
    _goodCtrl.dispose();
    _tomorrowMsgCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final r = widget.record;
    r.gratitude = _gratitudeCtrl.text.isNotEmpty ? _gratitudeCtrl.text : null;
    r.todayGoal = _goalCtrl.text.isNotEmpty ? _goalCtrl.text : null;
    r.reflectionGood = _goodCtrl.text.isNotEmpty ? _goodCtrl.text : null;
    r.tomorrowMessage = _tomorrowMsgCtrl.text.isNotEmpty ? _tomorrowMsgCtrl.text : null;
    await widget.onSave(r);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.record.date;
    final weekday = DateFormat.E('ja_JP').format(d);
    final dateStr = '${d.month}/${d.day} ($weekday)';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: GoogleFonts.zenKakuGothicNew(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: widget.onCancel,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'キャンセル',
                        style: GoogleFonts.zenKakuGothicNew(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _save,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Text(
                        '保存',
                        style: GoogleFonts.zenKakuGothicNew(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _editField('感謝していること', _gratitudeCtrl),
          const SizedBox(height: 12),
          _editField('今日やること', _goalCtrl),
          const SizedBox(height: 12),
          _editField('嬉しかったこと', _goodCtrl),
          const SizedBox(height: 12),
          _editField('明日の自分へ', _tomorrowMsgCtrl),
        ],
      ),
    );
  }

  Widget _editField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.zenKakuGothicNew(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        AppInput(
          controller: ctrl,
          maxLength: 200,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
