import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// 編集・削除の統一アクションバー
class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    this.onEdit,
    this.onDelete,
    this.editLabel = '編集',
    this.deleteLabel = '削除',
  });

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String editLabel;
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onEdit != null)
          Expanded(
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bgWarm,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    editLabel,
                    style: GoogleFonts.zenKakuGothicNew(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (onEdit != null && onDelete != null) const SizedBox(width: 8),
        if (onDelete != null)
          Expanded(
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bgWarm,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    deleteLabel,
                    style: GoogleFonts.zenKakuGothicNew(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFC17A56),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 統一された削除確認ダイアログ
Future<bool> showDeleteConfirmation(
  BuildContext context, {
  required String title,
  String message = 'この操作は取り消しできません',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title,
          style: GoogleFonts.zenKakuGothicNew(fontSize: 16)),
      content: Text(message,
          style: GoogleFonts.zenKakuGothicNew(
              fontSize: 14, color: AppColors.textSecondary)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text('キャンセル',
              style: GoogleFonts.zenKakuGothicNew(
                  color: AppColors.textMuted)),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text('削除',
              style: GoogleFonts.zenKakuGothicNew(
                  color: const Color(0xFFC17A56))),
        ),
      ],
    ),
  );
  return result ?? false;
}
