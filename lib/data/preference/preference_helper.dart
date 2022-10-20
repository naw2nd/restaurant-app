import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const reminderKey = 'REMINDER';

  Future<bool> get reminder async {
    final prefs = await sharedPreferences;
    return prefs.getBool(reminderKey) ?? false;
  }

  void setReminder(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(reminderKey, value);
  }
}
