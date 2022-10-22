import 'package:restaurant_app/data/model/received_notification.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class ScheduleService {
  static ScheduleService? _instance;
  ScheduleService._internal() {
    _configureLocalTimeZone();
    _instance = this;
  }

  factory ScheduleService() => _instance ?? ScheduleService._internal();

  scheduledFormPreference(int hour, ReceivedNotification notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool reminded = prefs.getBool('REMINDER') ?? false;
    if (reminded) {
      scheduleDailyNotification(hour, notification);
    } else {
      cancelAllSceduledNotification();
    }
  }

  scheduleDailyNotification(int hour, ReceivedNotification notification) {
    NotificationHelper notificationHelper = NotificationHelper();

    tz.TZDateTime scheduleTime = _nextInstanceOfHour(hour);

    notificationHelper.scheduledNotification(notification, scheduleTime);
  }

  cancelAllSceduledNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
