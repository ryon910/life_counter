import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/important_person.dart';
import '../../utils/date_validator.dart';
import '../../utils/freq_label.dart';
import '../shared/app_colors.dart';
import '../shared/app_picker.dart';
import '../shared/app_toast.dart';
import '../shared/app_button.dart';
import '../shared/app_input.dart';

class ImportantPersonFormPage extends StatefulWidget {
  const ImportantPersonFormPage({super.key, this.person});

  final ImportantPerson? person;

  static Future<ImportantPerson?> show(BuildContext context,
      {ImportantPerson? person}) {
    return showDialog<ImportantPerson>(
      context: context,
      barrierColor: const Color(0x662C2520),
      builder: (_) => ImportantPersonFormPage(person: person),
    );
  }

  @override
  State<ImportantPersonFormPage> createState() =>
      _ImportantPersonFormPageState();
}

class _ImportantPersonFormPageState extends State<ImportantPersonFormPage> {
  final _nickController = TextEditingController();
  int _year = 1965;
  int _month = 4;
  int _day = 1;
  Gender _gender = Gender.unspecified;
  int _freq = 4;
  DateTime? _lastMet;

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      final p = widget.person!;
      _nickController.text = p.nickname;
      _year = p.birthDate.year;
      _month = p.birthDate.month;
      _day = p.birthDate.day;
      _gender = p.gender;
      _freq = snapToNearestFreq(p.meetingFrequency);
      _lastMet = p.lastMetDate;
    }
  }

  @override
  void dispose() {
    _nickController.dispose();
    super.dispose();
  }

  void _submit() {
    final nick = _nickController.text.trim();
    if (nick.isEmpty) {
      AppToast.error(context, 'ニックネームを入力してください');
      return;
    }
    final error = DateValidator.validateBirthDate(_year, _month, _day);
    if (error != null) {
      AppToast.error(context, error);
      return;
    }
    final birthDate = DateTime(_year, _month, _day);
    final person = widget.person ?? ImportantPerson();
    person
      ..nickname = nick
      ..birthDate = birthDate
      ..gender = _gender
      ..meetingFrequency = _freq
      ..lastMetDate = _lastMet;
    Navigator.of(context).pop(person);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.person != null;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {}, // prevent dismiss on content tap
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? '大切な人を編集' : '大切な人を追加',
                    style: GoogleFonts.zenKakuGothicNew(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ニックネーム
                  _label('ニックネーム', required: true),
                  const SizedBox(height: 6),
                  AppInput(
                    controller: _nickController,
                    placeholder: '例: お母さん',
                    maxLength: 20,
                  ),
                  const SizedBox(height: 16),

                  // 性別
                  _label('性別'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      for (final g in [
                        (Gender.male, '男性'),
                        (Gender.female, '女性'),
                        (Gender.unspecified, '選択しない'),
                      ]) ...[
                        if (g.$1 != Gender.male) const SizedBox(width: 8),
                        Expanded(child: _genderBtn(g.$1, g.$2)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 生年月日
                  _label('生年月日', required: true),
                  const SizedBox(height: 6),
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
                  const SizedBox(height: 16),

                  // 会う頻度
                  _label('会う頻度', required: true),
                  const SizedBox(height: 6),
                  AppPicker<int>(
                    value: _freq,
                    displayText: freqToLabel(_freq),
                    title: '会う頻度',
                    options: meetingFrequencies
                        .map((f) =>
                            AppPickerOption(value: f.annual, label: f.label))
                        .toList(),
                    onChanged: (v) => setState(() => _freq = v),
                  ),
                  const SizedBox(height: 16),

                  // 最後に会った日
                  _label('最後に会った日（任意）'),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _lastMet ?? DateTime.now(),
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _lastMet = picked);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.bgWarm,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _lastMet != null
                            ? '${_lastMet!.year}/${_lastMet!.month}/${_lastMet!.day}'
                            : '選択してください',
                        style: GoogleFonts.zenKakuGothicNew(
                          fontSize: 14,
                          color: _lastMet != null
                              ? AppColors.text
                              : AppColors.textDisabled,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: AppButton.secondary(
                          onPressed: () => Navigator.of(context).pop(),
                          label: 'キャンセル',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton.primary(
                          onPressed: _submit,
                          label: isEdit ? '保存' : '追加',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, {bool required = false}) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: text,
          style: GoogleFonts.zenKakuGothicNew(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        if (required)
          TextSpan(
            text: ' *',
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 11,
              color: AppColors.accent,
            ),
          ),
      ]),
    );
  }

  Widget _genderBtn(Gender gender, String label) {
    final sel = _gender == gender;
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: sel ? AppColors.accentSurface2 : AppColors.bgWarm,
          border: Border.all(
              color: sel ? AppColors.borderAccent : AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.zenKakuGothicNew(
                fontSize: 12,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                color: sel ? AppColors.accent : AppColors.textSecondary,
              )),
        ),
      ),
    );
  }

}
