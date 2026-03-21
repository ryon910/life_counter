import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/important_person.dart';
import '../../providers/important_person_provider.dart';
import '../../providers/isar_provider.dart';
import '../../models/user_settings.dart';
import '../../providers/user_settings_provider.dart';
import '../../services/life_calculator.dart';
import '../../utils/freq_label.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';
import '../shared/app_button.dart';
import '../shared/premium_coming_soon_modal.dart';
import 'important_person_form_page.dart';
import 'important_person_detail_page.dart';

/// 大切な人セクション（プロトタイプの people セグメント再現）
class ImportantPeopleSection extends ConsumerStatefulWidget {
  const ImportantPeopleSection({super.key});

  @override
  ConsumerState<ImportantPeopleSection> createState() =>
      _ImportantPeopleSectionState();
}

class _ImportantPeopleSectionState
    extends ConsumerState<ImportantPeopleSection> {
  ImportantPerson? _selectedPerson;

  Future<void> _addPerson() async {
    final persons = ref.read(importantPersonsProvider).valueOrNull ?? [];
    if (persons.length >= 2) {
      PremiumComingSoonModal.show(context);
      return;
    }
    final result = await ImportantPersonFormPage.show(context);
    if (result != null) {
      await ref.read(importantPersonRepositoryProvider).add(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 詳細画面
    if (_selectedPerson != null) {
      return ImportantPersonDetailPage(
        person: _selectedPerson!,
        onBack: () => setState(() => _selectedPerson = null),
        onEdit: () async {
          final result = await ImportantPersonFormPage.show(
            context,
            person: _selectedPerson,
          );
          if (result != null) {
            final repo = ref.read(importantPersonRepositoryProvider);
            await repo.update(result);
            setState(() => _selectedPerson = result);
          }
        },
        onDelete: () async {
          final repo = ref.read(importantPersonRepositoryProvider);
          await repo.delete(_selectedPerson!.id);
          setState(() => _selectedPerson = null);
        },
      );
    }

    final personsAsync = ref.watch(importantPersonsProvider);
    final settings = ref.watch(userSettingsProvider);
    final myBirthDate = settings.birthDate;

    return personsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppCard(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          const Text('\u26A0\uFE0F', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text('データの読み込みに失敗しました',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ]),
      ),
      data: (persons) {
        if (persons.isEmpty) return _emptyState();
        return _personList(persons, myBirthDate, settings);
      },
    );
  }

  Widget _emptyState() {
    return AppCard(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text('\u{1F491}', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 20),
          Text(
            '大切な人を登録して\n一緒にいられる時間を\n確認しましょう',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.8,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),
          AppButton.primary(onPressed: _addPerson, label: '追加する'),
        ],
      ),
    );
  }

  Widget _personList(List<ImportantPerson> persons, DateTime? myBirthDate,
      UserSettings settings) {
    final fmt = NumberFormat('#,###', 'ja_JP');
    final myAge = myBirthDate != null
        ? LifeCalculator.currentAge(myBirthDate)
        : 0;
    final myAL = myBirthDate != null
        ? LifeCalculator.averageLifespan(settings.gender)
        : 84.07;

    return Column(
      children: [
        for (final p in persons) ...[
          _personCard(p, myAge, myAL, fmt),
          const SizedBox(height: 12),
        ],
        // 追加ボタン
        GestureDetector(
          onTap: () {
            if (persons.length >= 2) {
              PremiumComingSoonModal.show(context);
            } else {
              _addPerson();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.border,
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '+ 大切な人を追加',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Text(
                  persons.length >= 2
                      ? '3人目以降は Premium（準備中）'
                      : '無料で${2 - persons.length}人追加できます',
                  style: GoogleFonts.zenKakuGothicNew(
                    fontSize: 12,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _personCard(
      ImportantPerson p, int myAge, double myAL, NumberFormat fmt) {
    final pAge = LifeCalculator.currentAge(p.birthDate);
    final pAL = LifeCalculator.averageLifespan(p.gender);
    final pHL = LifeCalculator.healthyLifespan(p.gender);
    final pPastAL = pAge >= pAL;
    final myR = (myAL - myAge).clamp(0, 999);
    final pR = (pAL - pAge).clamp(0, 999);
    final together = myR < pR ? myR.floor() : pR.floor();
    final meet = calcMeetCount(together, p.meetingFrequency);
    final pHR = (pHL - pAge).clamp(0, 999).floor();

    return AppCard(
      onTap: () => setState(() => _selectedPerson = p),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(p.nickname,
                  style: GoogleFonts.zenKakuGothicNew(
                      fontSize: 17, fontWeight: FontWeight.w500)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgWarm,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$pAge歳',
                    style: GoogleFonts.zenKakuGothicNew(
                        fontSize: 11, color: AppColors.textMuted)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (pPastAL)
            Text(
              '${p.nickname}と過ごす毎日が、かけがえのない時間です',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            )
          else ...[
            Row(
              children: [
                Expanded(
                    child: _miniStat('平均寿命まで', '${pR.floor()}', '年')),
                const SizedBox(width: 12),
                Expanded(
                    child: pHR > 0
                        ? _miniStat('元気でいられる時間', '$pHR', '年',
                            valueColor: AppColors.accent)
                        : const SizedBox.shrink()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child:
                        _miniStat('一緒にいられる年数', '$together', '年')),
                const SizedBox(width: 12),
                Expanded(
                    child: _miniStat('会える残り回数', fmt.format(meet), '回',
                        valueColor: AppColors.accent)),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Text(
            '詳しく見る \u2192',
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 12,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _miniStat(String label, String value, String unit,
      {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label,
            style: GoogleFonts.zenKakuGothicNew(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Text.rich(TextSpan(children: [
          TextSpan(
            text: '約',
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: valueColor,
            ),
          ),
          TextSpan(
            text: unit,
            style: GoogleFonts.zenKakuGothicNew(
                fontSize: 11, color: AppColors.textMuted),
          ),
        ])),
      ],
    );
  }
}
