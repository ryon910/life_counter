import '../models/important_person.dart';

/// 寿命・人生日数の計算ロジック
class LifeCalculator {
  LifeCalculator._();

  /// 平均寿命（年）
  static double averageLifespan(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 81.05;
      case Gender.female:
        return 87.09;
      case Gender.unspecified:
        return 84.07;
    }
  }

  /// 健康寿命（年）
  static double healthyLifespan(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 72.68;
      case Gender.female:
        return 75.38;
      case Gender.unspecified:
        return 74.03;
    }
  }

  /// 誕生日から今日までの日数（1日目始まり）
  static int lifeDays(DateTime birthDate) {
    final today = DateTime.now();
    return today.difference(birthDate).inDays + 1;
  }

  /// 現在の年齢
  static int currentAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// 平均寿命までの残り日数
  static int remainingDays(DateTime birthDate, Gender gender) {
    final al = averageLifespan(gender);
    final daysSinceBirth = DateTime.now().difference(birthDate).inDays;
    return (al * 365.25 - daysSinceBirth).floor().clamp(0, 999999);
  }

  /// 健康寿命までの残り日数
  static int healthyRemainingDays(DateTime birthDate, Gender gender) {
    final hl = healthyLifespan(gender);
    final daysSinceBirth = DateTime.now().difference(birthDate).inDays;
    return (hl * 365.25 - daysSinceBirth).floor().clamp(0, 999999);
  }

  /// 残り年数
  static int remainingYears(DateTime birthDate, Gender gender) {
    final al = averageLifespan(gender);
    final age = currentAge(birthDate);
    return (al - age).floor().clamp(0, 999);
  }
}
