/// 会う頻度の定義（一元管理）
class MeetingFrequency {
  const MeetingFrequency(this.label, this.annual);
  final String label;
  final int annual;
}

/// 選択肢一覧（7択）
const meetingFrequencies = [
  MeetingFrequency('ほとんど毎日', 365),
  MeetingFrequency('週に1〜2回', 75),
  MeetingFrequency('月に1〜2回', 18),
  MeetingFrequency('数ヶ月に1回', 4),
  MeetingFrequency('年に1〜2回', 2),
  MeetingFrequency('年に1回以下', 1),
  MeetingFrequency('ほとんど会えない', 0),
];

/// 年間回数を自然な表現に変換
String freqToLabel(int annual) {
  for (final f in meetingFrequencies) {
    if (annual >= f.annual) return f.label;
  }
  return 'ほとんど会えない';
}

/// 会える残り回数の計算（切り上げ整数）
int calcMeetCount(int togetherYears, int annual) {
  if (annual <= 0) return 0;
  return togetherYears * annual;
}

/// 既存値を最も近い選択肢にスナップ
int snapToNearestFreq(int value) {
  final annuals = meetingFrequencies.map((f) => f.annual).toList();
  if (annuals.contains(value)) return value;
  return annuals.reduce(
      (a, b) => (a - value).abs() < (b - value).abs() ? a : b);
}
