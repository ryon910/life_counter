import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/great_person_service.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';
import '../shared/pill_label.dart';

/// 今日の偉人カード（プロトタイプにはないがPRD Epic 4に基づく実装）
class GreatPersonCard extends StatefulWidget {
  const GreatPersonCard({super.key, required this.userAge});
  final int userAge;

  @override
  State<GreatPersonCard> createState() => _GreatPersonCardState();
}

class _GreatPersonCardState extends State<GreatPersonCard> {
  Map<String, dynamic>? _episode;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ep = await GreatPersonService.todayEpisode(widget.userAge);
    if (mounted) setState(() => _episode = ep);
  }

  @override
  Widget build(BuildContext context) {
    if (_episode == null) return const SizedBox.shrink();
    final ep = _episode!;

    return AppCard(
      onTap: () => _showDetail(context, ep),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PillLabel(text: _typeEmoji(ep['type'] as String)),
              const SizedBox(width: 8),
              Text(
                '今日の偉人',
                style: AppTextStyles.label.copyWith(letterSpacing: 0),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${ep['achieveAge']}歳の時、${ep['name']}は${ep['text']}',
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  String _typeEmoji(String type) {
    switch (type) {
      case '奮起':
        return '\u{1F525}'; // 🔥
      case '勇気':
        return '\u{1F981}'; // 🦁
      case '気づき':
        return '\u{1F4A1}'; // 💡
      case '発奮':
        return '\u2B50'; // ⭐
      default:
        return '\u2728';
    }
  }

  void _showDetail(BuildContext context, Map<String, dynamic> ep) {
    final achievements =
        List<Map<String, dynamic>>.from(ep['achievements'] ?? []);
    final birth = ep['birth'];
    final death = ep['death'];
    final lifespan =
        death != null ? '$birth - $death' : '$birth -';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.bgSub,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(ep['name'] as String, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 4),
              Text(lifespan,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 20),
              // 業績リスト
              for (final a in achievements) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${a['age']}歳',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          a['text'] as String,
                          style: GoogleFonts.zenKakuGothicNew(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (ep['quote'] != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgWarm,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '「${ep['quote']}」',
                    style: GoogleFonts.zenKakuGothicNew(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.8,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
