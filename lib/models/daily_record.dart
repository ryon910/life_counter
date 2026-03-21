import 'package:isar/isar.dart';

part 'daily_record.g.dart';

@collection
class DailyRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  String? todayGoal;

  String? reflectionGood;
  String? reflectionWhy;
  String? reflectionTomorrow;

  String? weeklyReflectionHighlight;
  String? weeklyReflectionChange;

  String? morningQuestionId;
  String? greatPersonId;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
