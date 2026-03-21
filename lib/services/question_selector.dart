import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PERMAベースの問いかけ選出ロジック
/// - 曜日連動: 月曜=A, 火曜=E, 水曜=R, 木曜=M, 金曜=P, 土曜=均等, 日曜=M
/// - 14日以内に同じ問いかけを繰り返さない
class QuestionSelector {
  QuestionSelector._();

  static List<Map<String, dynamic>>? _allQuestions;

  static const _recentKey = 'recent_question_ids';

  /// 曜日→カテゴリのマッピング（PRD仕様）
  static const _weekdayCategory = {
    DateTime.monday: 'A',
    DateTime.tuesday: 'E',
    DateTime.wednesday: 'R',
    DateTime.thursday: 'M',
    DateTime.friday: 'P',
    DateTime.sunday: 'M',
    // 土曜は均等ローテーション（null）
  };

  static Future<List<Map<String, dynamic>>> _loadAll() async {
    if (_allQuestions != null) return _allQuestions!;
    try {
      final json =
          await rootBundle.loadString('assets/data/coaching_questions.json');
      _allQuestions = List<Map<String, dynamic>>.from(jsonDecode(json));
      return _allQuestions!;
    } catch (e) {
      debugPrint('QuestionSelector load error: $e');
      return [
        {'id': 'fallback', 'category': 'P', 'text': '今日、感謝できることは何ですか？'}
      ];
    }
  }

  /// 今日の問いかけを選出
  static Future<Map<String, dynamic>> selectToday(
      SharedPreferences prefs) async {
    final questions = await _loadAll();
    final today = DateTime.now();
    final recentIds = prefs.getStringList(_recentKey) ?? [];

    // 曜日に対応するカテゴリを取得
    final targetCategory = _weekdayCategory[today.weekday];

    // 候補を絞り込み
    List<Map<String, dynamic>> candidates;
    if (targetCategory != null) {
      // 特定カテゴリから選ぶ（14日以内の重複を除外）
      candidates = questions
          .where((q) =>
              q['category'] == targetCategory &&
              !recentIds.contains(q['id']))
          .toList();
      // 候補がなければカテゴリ内の全問から（重複許容）
      if (candidates.isEmpty) {
        candidates = questions
            .where((q) => q['category'] == targetCategory)
            .toList();
      }
    } else {
      // 土曜: 全カテゴリから均等（14日以内の重複を除外）
      candidates =
          questions.where((q) => !recentIds.contains(q['id'])).toList();
      if (candidates.isEmpty) candidates = questions;
    }

    // 日付ベースで決定的に選出（同じ日なら同じ問い）
    final dayOfYear = today.difference(DateTime(today.year)).inDays;
    final selected = candidates[dayOfYear % candidates.length];

    // 最近の問いかけリストを更新（14日分を保持）
    final selectedId = selected['id'] as String;
    final updatedRecent = [selectedId, ...recentIds];
    if (updatedRecent.length > 14) {
      updatedRecent.removeRange(14, updatedRecent.length);
    }
    await prefs.setStringList(_recentKey, updatedRecent);

    return selected;
  }
}
