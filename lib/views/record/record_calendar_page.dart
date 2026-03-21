import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/daily_record.dart';
import '../../providers/isar_provider.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';
import '../shared/app_segmented_control.dart';
import 'record_detail_page.dart';

/// 記録タブ（プロトタイプの RecordsTab 再現）
class RecordCalendarPage extends ConsumerStatefulWidget {
  const RecordCalendarPage({super.key});

  @override
  ConsumerState<RecordCalendarPage> createState() =>
      _RecordCalendarPageState();
}

enum _RecordView { calendar, list }

class _RecordCalendarPageState extends ConsumerState<RecordCalendarPage> {
  _RecordView _view = _RecordView.calendar;
  DateTime _focusedDay = DateTime.now();
  DailyRecord? _selectedRecord;
  List<DailyRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final repo = ref.read(dailyRecordRepositoryProvider);
    final records = await repo.getAll();
    if (mounted) setState(() => _records = records);
  }

  Set<DateTime> get _recordDates {
    return _records
        .map((r) => DateTime(r.date.year, r.date.month, r.date.day))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    // 詳細画面
    if (_selectedRecord != null) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 130),
          child: RecordDetailPage(
            record: _selectedRecord!,
            onBack: () => setState(() {
              _selectedRecord = null;
              _loadRecords();
            }),
            onDelete: () async {
              final repo = ref.read(dailyRecordRepositoryProvider);
              await repo.delete(_selectedRecord!.id);
              setState(() {
                _selectedRecord = null;
                _loadRecords();
              });
            },
            onSave: (record) async {
              final repo = ref.read(dailyRecordRepositoryProvider);
              await repo.save(record);
              _loadRecords();
            },
          ),
        ),
      );
    }

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
                  SegmentItem(value: _RecordView.calendar, label: 'カレンダー'),
                  SegmentItem(value: _RecordView.list, label: 'リスト'),
                ],
                selectedValue: _view,
                onChanged: (v) => setState(() => _view = v),
              ),
            ),
            const SizedBox(height: 24),
            if (_view == _RecordView.calendar)
              _buildCalendar()
            else
              _buildList(),
          ],
        ),
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
          final record = await repo.getByDate(selected);
          if (record != null && mounted) {
            setState(() => _selectedRecord = record);
          }
        },
        onPageChanged: (focused) => _focusedDay = focused,
      ),
    );
  }

  Widget _buildList() {
    if (_records.isEmpty) {
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
      children: _records.map((r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppCard(
            onTap: () => setState(() => _selectedRecord = r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${r.date.month}月${r.date.day}日',
                      style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (r.todayGoal != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        r.todayGoal!,
                        style: GoogleFonts.zenKakuGothicNew(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ],
                ),
                Text('\u203A',
                    style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 12, color: AppColors.textDisabled)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
