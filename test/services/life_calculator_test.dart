import 'package:flutter_test/flutter_test.dart';
import 'package:life_counter/models/important_person.dart';
import 'package:life_counter/services/life_calculator.dart';

void main() {
  group('LifeCalculator', () {
    test('平均寿命の値が正しい', () {
      expect(LifeCalculator.averageLifespan(Gender.male), 81.05);
      expect(LifeCalculator.averageLifespan(Gender.female), 87.09);
      expect(LifeCalculator.averageLifespan(Gender.unspecified), 84.07);
    });

    test('健康寿命の値が正しい', () {
      expect(LifeCalculator.healthyLifespan(Gender.male), 72.68);
      expect(LifeCalculator.healthyLifespan(Gender.female), 75.38);
      expect(LifeCalculator.healthyLifespan(Gender.unspecified), 74.03);
    });

    test('lifeDays: 生まれた日が1日目', () {
      final today = DateTime.now();
      final birthDate = DateTime(today.year, today.month, today.day);
      expect(LifeCalculator.lifeDays(birthDate), 1);
    });

    test('lifeDays: 昨日生まれなら2日目', () {
      final yesterday =
          DateTime.now().subtract(const Duration(days: 1));
      final birthDate =
          DateTime(yesterday.year, yesterday.month, yesterday.day);
      expect(LifeCalculator.lifeDays(birthDate), 2);
    });

    test('currentAge: 30歳のユーザー', () {
      final today = DateTime.now();
      final birthDate = DateTime(today.year - 30, today.month, today.day);
      expect(LifeCalculator.currentAge(birthDate), 30);
    });

    test('remainingDays: 正の値を返す', () {
      final birthDate = DateTime(1995, 1, 1);
      final remaining =
          LifeCalculator.remainingDays(birthDate, Gender.male);
      expect(remaining, greaterThan(0));
    });

    test('remainingDays: 非常に高齢なら0', () {
      final birthDate = DateTime(1900, 1, 1);
      final remaining =
          LifeCalculator.remainingDays(birthDate, Gender.male);
      expect(remaining, 0);
    });

    test('remainingYears: 正の整数を返す', () {
      final birthDate = DateTime(1995, 1, 1);
      final years =
          LifeCalculator.remainingYears(birthDate, Gender.male);
      expect(years, greaterThan(0));
      expect(years, lessThan(100));
    });
  });
}
