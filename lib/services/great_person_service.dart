import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 偉人データの読み込みと選出ロジック
class GreatPersonService {
  GreatPersonService._();

  static List<Map<String, dynamic>>? _cache;

  static Future<List<Map<String, dynamic>>> loadAll() async {
    if (_cache != null) return _cache!;
    try {
      final json =
          await rootBundle.loadString('assets/data/great_persons.json');
      _cache = List<Map<String, dynamic>>.from(jsonDecode(json));
      return _cache!;
    } catch (e) {
      debugPrint('GreatPersonService load error: $e');
      return [];
    }
  }

  /// 今日の偉人エピソード（ユーザーの年齢±5歳の範囲で選出）
  static Future<Map<String, dynamic>?> todayEpisode(int userAge) async {
    final persons = await loadAll();
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year)).inDays;

    // 年齢±5の範囲に該当するachievementsを集める
    final candidates = <Map<String, dynamic>>[];
    for (final p in persons) {
      final achievements =
          List<Map<String, dynamic>>.from(p['achievements'] ?? []);
      for (final a in achievements) {
        final achieveAge = a['age'] as int;
        if ((achieveAge - userAge).abs() <= 5) {
          candidates.add({
            'name': p['name'],
            'quote': p['quote'],
            'birth': p['birth'],
            'death': p['death'],
            'achieveAge': achieveAge,
            'text': a['text'],
            'type': a['type'],
            'achievements': achievements,
          });
        }
      }
    }

    if (candidates.isEmpty) {
      // フォールバック: 全achievementから選ぶ
      for (final p in persons) {
        final achievements =
            List<Map<String, dynamic>>.from(p['achievements'] ?? []);
        for (final a in achievements) {
          candidates.add({
            'name': p['name'],
            'quote': p['quote'],
            'birth': p['birth'],
            'death': p['death'],
            'achieveAge': a['age'],
            'text': a['text'],
            'type': a['type'],
            'achievements': achievements,
          });
        }
      }
    }

    if (candidates.isEmpty) return null;
    return candidates[dayOfYear % candidates.length];
  }
}
