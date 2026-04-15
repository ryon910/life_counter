import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/important_person.dart';
import '../../models/user_settings.dart';
import '../../providers/user_settings_provider.dart';
import '../../services/notification_service.dart';
import '../shared/app_colors.dart';
import '../shared/app_toast.dart';
import '../shared/app_text_styles.dart';
import '../shared/app_card.dart';

/// マイページタブ（プロトタイプのMyPageTab再現 + Epic 9 設定編集UI）
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    final bd = settings.birthDate;
    final bdText = bd != null ? '${bd.year}/${bd.month}/${bd.day}' : '---';
    final genText = switch (settings.gender) {
      Gender.male => '男性',
      Gender.female => '女性',
      Gender.unspecified => '選択しない',
    };
    final notifText = settings.notificationEnabled
        ? 'ON \u30FB ${settings.notificationHour}:${settings.notificationMinute.toString().padLeft(2, '0')}'
        : 'OFF';
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 48, 20, 130),
        child: Column(
          children: [
            Text('MY PAGE', style: AppTextStyles.labelUppercase),
            const SizedBox(height: 28),

            AppCard(
              child: Column(
                children: [
                  _settingsRow(
                    '\u{1F4C5}', '生年月日', bdText,
                    onTap: () => _editBirthDate(context, ref, settings),
                  ),
                  _divider(),
                  _settingsRow(
                    '\u{1F464}', '性別', genText,
                    onTap: () => _editGender(context, ref, settings),
                  ),
                  _divider(),
                  _settingsRow(
                    '\u{1F514}', '朝の通知', notifText,
                    onTap: () => _editNotification(context, ref, settings),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            AppCard(
              child: Column(
                children: [
                  _linkRow('フィードバックを送る',
                      onTap: () => _sendFeedback(context)),
                  _divider(),
                  _linkRow('プライバシーポリシー',
                      onTap: () => _showLegal(context, 'privacy_policy.html',
                          'プライバシーポリシー')),
                  _divider(),
                  _linkRow('利用規約',
                      onTap: () => _showLegal(
                          context, 'terms_of_service.html', '利用規約')),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text(
              'LifeCounter v1.0.2',
              style: AppTextStyles.caption
                  .copyWith(fontSize: 11, color: AppColors.textDisabled),
            ),
          ],
        ),
      ),
    );
  }

  // ─── フィードバック ───

  void _sendFeedback(BuildContext context) {
    final uri = Uri(
      scheme: 'mailto',
      path: 'ryo.nakano.biz+lifecounter@gmail.com',
      query: 'subject=LifeCounter フィードバック&body=\n\n---\nLifeCounter v1.0.2',
    );
    launchUrl(uri);
  }

  // ─── 法的ページ ───

  void _showLegal(BuildContext context, String fileName, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LegalPage(fileName: fileName, title: title),
      ),
    );
  }

  // ─── 設定編集 ───

  void _editBirthDate(
      BuildContext context, WidgetRef ref, UserSettings settings) async {
    final current = settings.birthDate ?? DateTime(1995, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      await ref
          .read(userSettingsProvider.notifier)
          .setBirthDateAndGender(picked, settings.gender);
    }
  }

  void _editGender(
      BuildContext context, WidgetRef ref, UserSettings settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('性別を選択',
                  style: GoogleFonts.zenKakuGothicNew(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              for (final g in [
                (Gender.male, '男性'),
                (Gender.female, '女性'),
                (Gender.unspecified, '選択しない'),
              ])
                ListTile(
                  title: Text(g.$2),
                  trailing: settings.gender == g.$1
                      ? const Icon(Icons.check, color: AppColors.accent)
                      : null,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    if (settings.birthDate != null) {
                      await ref
                          .read(userSettingsProvider.notifier)
                          .setBirthDateAndGender(settings.birthDate!, g.$1);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _editNotification(
      BuildContext context, WidgetRef ref, UserSettings settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('朝の通知',
                  style: GoogleFonts.zenKakuGothicNew(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('通知を有効にする'),
                value: settings.notificationEnabled,
                activeTrackColor: AppColors.accent,
                onChanged: (v) async {
                  if (v) {
                    await NotificationService.requestPermission();
                  }
                  await ref
                      .read(userSettingsProvider.notifier)
                      .updateNotification(
                        enabled: v,
                        hour: settings.notificationHour,
                        minute: settings.notificationMinute,
                      );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                title: const Text('通知時刻'),
                trailing: Text(
                  '${settings.notificationHour}:${settings.notificationMinute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.zenKakuGothicNew(
                      color: AppColors.textMuted),
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: settings.notificationHour,
                      minute: settings.notificationMinute,
                    ),
                  );
                  if (picked != null) {
                    if (picked.hour < 5 || picked.hour > 11) {
                      if (context.mounted) {
                        AppToast.error(context,
                            '5:00〜11:00 の範囲で設定してください');
                      }
                      return;
                    }
                    await ref
                        .read(userSettingsProvider.notifier)
                        .updateNotification(
                          enabled: settings.notificationEnabled,
                          hour: picked.hour,
                          minute: picked.minute,
                        );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── UI ───

  static Widget _settingsRow(String emoji, String label, String value,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 12),
            Text(label,
                style: GoogleFonts.zenKakuGothicNew(
                    fontSize: 14, color: AppColors.text)),
            const Spacer(),
            Text('$value \u203A',
                style: GoogleFonts.zenKakuGothicNew(
                    fontSize: 13, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  static Widget _linkRow(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text('$label \u203A',
                style: GoogleFonts.zenKakuGothicNew(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textSecondary,
                )),
          ],
        ),
      ),
    );
  }

  static Widget _divider() =>
      const Divider(height: 1, color: AppColors.border);
}

/// 法的ページ（HTML表示）
class _LegalPage extends StatelessWidget {
  const _LegalPage({required this.fileName, required this.title});
  final String fileName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(title,
            style: GoogleFonts.zenKakuGothicNew(
                fontSize: 16, color: AppColors.text)),
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/legal/$fileName'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          // HTMLからbody内テキストをシンプル表示
          final html = snapshot.data!;
          final sections = _parseHtml(html);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sections,
            ),
          );
        },
      ),
    );
  }

  List<Widget> _parseHtml(String html) {
    final widgets = <Widget>[];
    // 簡易HTMLパーサー（h2, p, li を抽出）
    final h2Regex = RegExp(r'<h2>(.*?)</h2>');
    final pRegex = RegExp(r'<p(?:\s[^>]*)?>(.*?)</p>', dotAll: true);
    final liRegex = RegExp(r'<li>(.*?)</li>', dotAll: true);

    final lines = html.split('\n');
    for (final line in lines) {
      final h2Match = h2Regex.firstMatch(line);
      if (h2Match != null) {
        widgets.add(const SizedBox(height: 20));
        widgets.add(Text(
          _stripTags(h2Match.group(1)!),
          style: GoogleFonts.zenKakuGothicNew(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ));
        widgets.add(const SizedBox(height: 8));
        continue;
      }
      final pMatch = pRegex.firstMatch(line);
      if (pMatch != null) {
        final text = _stripTags(pMatch.group(1)!).trim();
        if (text.isNotEmpty) {
          widgets.add(Text(
            text,
            style: GoogleFonts.zenKakuGothicNew(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.8,
            ),
          ));
          widgets.add(const SizedBox(height: 4));
        }
        continue;
      }
      final liMatch = liRegex.firstMatch(line);
      if (liMatch != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('・ ',
                  style: GoogleFonts.zenKakuGothicNew(
                      fontSize: 14, color: AppColors.textSecondary)),
              Expanded(
                child: Text(
                  _stripTags(liMatch.group(1)!).trim(),
                  style: GoogleFonts.zenKakuGothicNew(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
        ));
      }
    }
    return widgets;
  }

  String _stripTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
