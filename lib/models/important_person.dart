import 'package:isar/isar.dart';

part 'important_person.g.dart';

@collection
class ImportantPerson {
  Id id = Isar.autoIncrement;

  late String nickname;
  late DateTime birthDate;

  @Enumerated(EnumType.name)
  Gender gender = Gender.unspecified;

  /// 年間の会う回数
  int meetingFrequency = 4;

  DateTime? lastMetDate;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}

enum Gender {
  male,
  female,
  unspecified,
}
