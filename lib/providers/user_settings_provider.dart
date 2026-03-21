import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';
import '../models/important_person.dart';
import '../utils/prefs_keys.dart';

/// SharedPreferencesのプロバイダー
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main.dart');
});

/// ユーザー設定のプロバイダー
final userSettingsProvider =
    NotifierProvider<UserSettingsNotifier, UserSettings>(
  UserSettingsNotifier.new,
);

class UserSettingsNotifier extends Notifier<UserSettings> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  UserSettings build() {
    try {
      final bdMillis = _prefs.getInt(PrefsKeys.birthDate);
      return UserSettings(
        birthDate: bdMillis != null
            ? DateTime.fromMillisecondsSinceEpoch(bdMillis)
            : null,
        gender: Gender.values.byName(
          _prefs.getString(PrefsKeys.gender) ?? Gender.unspecified.name,
        ),
        onboardingCompleted:
            _prefs.getBool(PrefsKeys.onboardingCompleted) ?? false,
        notificationEnabled:
            _prefs.getBool(PrefsKeys.notificationEnabled) ?? true,
        notificationHour: _prefs.getInt(PrefsKeys.notificationHour) ?? 7,
        notificationMinute: _prefs.getInt(PrefsKeys.notificationMinute) ?? 0,
        nightModeHour: _prefs.getInt(PrefsKeys.nightModeHour) ?? 18,
        nightModeMinute: _prefs.getInt(PrefsKeys.nightModeMinute) ?? 0,
      );
    } catch (e) {
      debugPrint('UserSettings load error: $e');
      return const UserSettings();
    }
  }

  Future<void> setBirthDateAndGender(
      DateTime birthDate, Gender gender) async {
    await _prefs.setInt(PrefsKeys.birthDate, birthDate.millisecondsSinceEpoch);
    await _prefs.setString(PrefsKeys.gender, gender.name);
    state = state.copyWith(birthDate: birthDate, gender: gender);
  }

  Future<void> completeOnboarding() async {
    await _prefs.setBool(PrefsKeys.onboardingCompleted, true);
    state = state.copyWith(onboardingCompleted: true);
  }

  Future<void> updateNightMode(int hour, int minute) async {
    await _prefs.setInt(PrefsKeys.nightModeHour, hour);
    await _prefs.setInt(PrefsKeys.nightModeMinute, minute);
    state = state.copyWith(nightModeHour: hour, nightModeMinute: minute);
  }

  Future<void> updateNotification({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    await _prefs.setBool(PrefsKeys.notificationEnabled, enabled);
    await _prefs.setInt(PrefsKeys.notificationHour, hour);
    await _prefs.setInt(PrefsKeys.notificationMinute, minute);
    state = state.copyWith(
      notificationEnabled: enabled,
      notificationHour: hour,
      notificationMinute: minute,
    );
  }
}
