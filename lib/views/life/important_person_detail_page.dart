import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/important_person.dart';
import '../../providers/user_settings_provider.dart';
import '../../services/life_calculator.dart';
import '../../utils/freq_label.dart';
import '../shared/action_buttons.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';

/// 大切な人の詳細画面（プロトタイプの showPD 再現）
class ImportantPersonDetailPage extends ConsumerWidget {
  const ImportantPersonDetailPage({
    super.key,
    required this.person,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });

  final ImportantPerson person;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    final myBirthDate = settings.birthDate;
    if (myBirthDate == null) return const SizedBox.shrink();

    final myAge = LifeCalculator.currentAge(myBirthDate);
    final myAL = LifeCalculator.averageLifespan(settings.gender);

    final pAge = LifeCalculator.currentAge(person.birthDate);
    final pAL = LifeCalculator.averageLifespan(person.gender);
    final pHL = LifeCalculator.healthyLifespan(person.gender);
    final pPastAL = pAge >= pAL;

    final myRemaining = (myAL - myAge).clamp(0, 999).floor();
    final pRemaining = (pAL - pAge).clamp(0, 999).floor();
    final together = (myRemaining < pRemaining ? myRemaining : pRemaining)
        .clamp(0, 999);
    final meetCount = calcMeetCount(together, person.meetingFrequency);
    final pHealthRemaining = (pHL - pAge).clamp(0, 999).floor();

    final lastMetDays = person.lastMetDate != null
        ? DateTime.now().difference(person.lastMetDate!).inDays
        : null;

    final fmt = NumberFormat('#,###', 'ja_JP');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 戻るボタン
        GestureDetector(
          onTap: onBack,
          child: Text(
            '\u2190 戻る',
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 13,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.nickname,
                      style: AppTextStyles.headlineSmall
                          .copyWith(fontSize: 28)),
                  const SizedBox(height: 4),
                  Text('$pAge歳',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text('編集',
                    style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 12, color: AppColors.accent)),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final confirmed = await showDeleteConfirmation(
                  context,
                  title: '${person.nickname}を削除しますか？',
                );
                if (confirmed) onDelete();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text('削除',
                    style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 12, color: const Color(0xFFC17A56))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        if (pPastAL)
          AppCard(
            child: Center(
              child: Text(
                '${person.nickname}と過ごす毎日が、\nかけがえのない時間です',
                textAlign: TextAlign.center,
                style: GoogleFonts.zenKakuGothicNew(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  height: 1.8,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else ...[
          _statCard('平均寿命まで', '$pRemaining', '年'),
          if (pHealthRemaining > 0) ...[
            const SizedBox(height: 12),
            _statCard('元気でいられる時間', '$pHealthRemaining', '年'),
          ],
          const SizedBox(height: 12),
          _statCard('一緒にいられる年数', '$together', '年',
              sub: '自分と相手の平均寿命の早い方'),
          const SizedBox(height: 12),
          _statCard('会える残り回数', fmt.format(meetCount), '回',
              sub: '${freqToLabel(person.meetingFrequency)}会う場合',
              valueColor: AppColors.accent),
          if (lastMetDays != null) ...[
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('最後に会ってから',
                      style: AppTextStyles.label.copyWith(letterSpacing: 0)),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: '$lastMetDays',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: lastMetDays > 60
                              ? const Color(0xFFC17A56)
                              : AppColors.text,
                        ),
                      ),
                      TextSpan(
                        text: ' 日',
                        style: GoogleFonts.zenKakuGothicNew(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ]),
                  ),
                  if (lastMetDays > 90) ...[
                    const SizedBox(height: 8),
                    Text(
                      'そろそろ会いたくなりませんか？',
                      style: AppTextStyles.caption
                          .copyWith(fontSize: 12, color: AppColors.accent),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  static Widget _statCard(String label, String value, String unit,
      {String? sub, Color? valueColor}) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.label.copyWith(letterSpacing: 0)),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'あと約 ',
                style: GoogleFonts.zenKakuGothicNew(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textMuted,
                ),
              ),
              TextSpan(
                text: value,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: valueColor ?? AppColors.text,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: GoogleFonts.zenKakuGothicNew(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ]),
            textAlign: TextAlign.left,
          ),
          if (sub != null) ...[
            const SizedBox(height: 6),
            Text(sub,
                style: GoogleFonts.zenKakuGothicNew(
                    fontSize: 11, color: AppColors.textDisabled)),
          ],
        ],
      ),
    );
  }

}
