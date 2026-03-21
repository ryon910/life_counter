import 'important_person.dart';

/// SharedPreferencesで保存するユーザー設定（immutable pattern）
class UserSettings {
  const UserSettings({
    this.birthDate,
    this.gender = Gender.unspecified,
    this.onboardingCompleted = false,
    this.notificationEnabled = true,
    this.notificationHour = 7,
    this.notificationMinute = 0,
    this.nightModeHour = 18,
    this.nightModeMinute = 0,
  });

  final DateTime? birthDate;
  final Gender gender;
  final bool onboardingCompleted;
  final bool notificationEnabled;
  final int notificationHour;
  final int notificationMinute;
  final int nightModeHour;
  final int nightModeMinute;

  UserSettings copyWith({
    DateTime? birthDate,
    Gender? gender,
    bool? onboardingCompleted,
    bool? notificationEnabled,
    int? notificationHour,
    int? notificationMinute,
    int? nightModeHour,
    int? nightModeMinute,
  }) {
    return UserSettings(
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      nightModeHour: nightModeHour ?? this.nightModeHour,
      nightModeMinute: nightModeMinute ?? this.nightModeMinute,
    );
  }
}
