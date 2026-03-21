import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/important_person.dart';
import '../../utils/date_validator.dart';
import '../shared/app_colors.dart';
import '../shared/app_toast.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_button.dart';
import '../shared/pill_label.dart';

/// 生年月日・性別入力画面（プロトタイプの birth 再現）
class BirthInputPage extends StatefulWidget {
  const BirthInputPage({super.key, required this.onNext});

  final void Function(DateTime birthDate, Gender gender) onNext;

  @override
  State<BirthInputPage> createState() => _BirthInputPageState();
}

class _BirthInputPageState extends State<BirthInputPage> {
  int _year = 1995;
  int _month = 1;
  int _day = 1;
  Gender _gender = Gender.unspecified;

  void _handleNext() {
    final error = DateValidator.validateBirthDate(_year, _month, _day);
    if (error != null) {
      AppToast.error(context, error);
      return;
    }
    final date = DateTime(_year, _month, _day);
    widget.onNext(date, _gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const PillLabel(text: 'STEP 1'),
              const SizedBox(height: 20),
              Text(
                'あなたのことを教えてください',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '人生の日数と平均寿命の計算に使用します',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 36),

              // 性別（任意）
              Text('性別（任意）', style: AppTextStyles.label),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final g in [
                    (Gender.male, '男性'),
                    (Gender.female, '女性'),
                    (Gender.unspecified, '選択しない'),
                  ]) ...[
                    if (g.$1 != Gender.male) const SizedBox(width: 10),
                    Expanded(child: _genderButton(g.$1, g.$2)),
                  ],
                ],
              ),
              const SizedBox(height: 28),

              // 生年月日
              Text('生年月日', style: AppTextStyles.label),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(_year, _month, _day),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _year = picked.year;
                      _month = picked.month;
                      _day = picked.day;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.bgWarm,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$_year年$_month月$_day日',
                          style: GoogleFonts.zenKakuGothicNew(
                            fontSize: 15,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_today_rounded,
                          color: AppColors.textMuted, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              AppButton.primary(onPressed: _handleNext, label: '次へ'),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _genderButton(Gender gender, String label) {
    final isSelected = _gender == gender;
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentSurface2 : AppColors.bgWarm,
          border: Border.all(
            color: isSelected ? AppColors.borderAccent : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

}
