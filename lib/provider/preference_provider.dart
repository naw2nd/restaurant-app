import 'package:flutter/material.dart';
import 'package:restaurant_app/data/preference/preference_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getReminderPreference();
  }

  bool _reminder = true;
  bool get reminder => _reminder;

  void _getReminderPreference() async {
    _reminder = await preferencesHelper.reminder;
    notifyListeners();
  }

  void setReminder(bool value) {
    preferencesHelper.setReminder(value);
    _getReminderPreference();
  }
}
