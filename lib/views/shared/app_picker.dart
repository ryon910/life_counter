import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// 統一ピッカー（タップでボトムシートを開くセレクトUI）
class AppPicker<T> extends StatelessWidget {
  const AppPicker({
    super.key,
    required this.value,
    required this.displayText,
    required this.options,
    required this.onChanged,
    this.title,
  });

  final T value;
  final String displayText;
  final List<AppPickerOption<T>> options;
  final ValueChanged<T> onChanged;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgWarm,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: GoogleFonts.zenKakuGothicNew(
                  fontSize: 15,
                  color: AppColors.text,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _PickerSheet<T>(
        title: title,
        options: options,
        selectedValue: value,
        onSelected: (v) {
          Navigator.of(ctx).pop();
          onChanged(v);
        },
      ),
    );
  }
}

class AppPickerOption<T> {
  const AppPickerOption({required this.value, required this.label});
  final T value;
  final String label;
}

class _PickerSheet<T> extends StatelessWidget {
  const _PickerSheet({
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.title,
  });

  final String? title;
  final List<AppPickerOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.5;
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ハンドル
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.bgSub,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                title!,
                style: GoogleFonts.zenKakuGothicNew(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ),
          const Divider(height: 1, color: AppColors.border),
          // 選択肢リスト
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option.value == selectedValue;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(option.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    color: isSelected
                        ? AppColors.accentSurface
                        : Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: GoogleFonts.zenKakuGothicNew(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.text,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_rounded,
                            color: AppColors.accent,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
