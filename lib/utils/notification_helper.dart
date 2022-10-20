import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/model/received_notification.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

String? selectedNotificationPayload;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _initializeNotficationService();
    _instance = this;
  }

  factory NotificationHelper() {
    return _instance ?? NotificationHelper._internal();
  }

  Future<void> _initializeNotficationService() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        selectNotificationStream.add(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<bool> isAppLaunchedByNotification() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      return true;
    }
    return false;
  }

  Future<void> scheduledNotification(ReceivedNotification receivedNotification,
      tz.TZDateTime scheduledDate) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        receivedNotification.title,
        receivedNotification.body,
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'ch-1',
          'main channel',
          importance: Importance.max,
          priority: Priority.high,
        )),
        androidAllowWhileIdle: true,
        payload: receivedNotification.payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
