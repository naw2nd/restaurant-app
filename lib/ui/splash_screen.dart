import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/received_notification.dart';
import 'package:restaurant_app/provider/home_provider.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/restaurant_list_page.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/utils/schedule_service.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAppLaunchedByNotification = false;
  void _navigationToNextPage() {
    Navigator.pushReplacementNamed(context, RestaurantListPage.routeName);
    _initScheduler(11);

    if (isAppLaunchedByNotification) {
      Provider.of<RestaurantProvider>(context, listen: false)
          .fetchRestaurantDetail(selectedNotificationPayload ?? '');
      Navigator.pushNamed(context, RestaurantDetailPage.routeName,
          arguments: selectedNotificationPayload);
    }
  }

  _initNotification() async {
    NotificationHelper notificationHelper = NotificationHelper();
    isAppLaunchedByNotification =
        await notificationHelper.isAppLaunchedByNotification();
  }

  _initScheduler(int hour) async {
    ReceivedNotification notification;
    ScheduleService scheduleService = ScheduleService();
    HomeProvider providerHome =
        Provider.of<HomeProvider>(context, listen: false);
    PreferencesProvider providerPrefs =
        Provider.of<PreferencesProvider>(context, listen: false);
    dynamic restaurant = await providerHome.getPromotedRestaurant();
    // print(Provider.of<HomeProvider>(context, listen: false).state);
    if (providerHome.state == StateHP.hasData) {
      notification = ReceivedNotification(
          title: 'Promo in ${restaurant.city} City',
          body: 'Restaurant ${restaurant.name}',
          payload: restaurant.id);
      scheduleService.scheduledFormPreference(hour, notification);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Notification has turned off because your device is not connected to internet!')));
      providerPrefs.setReminder(false);
    }
  }

  _startSplashScreenTimer() async {
    var duration = const Duration(seconds: 2);

    return Timer(duration, _navigationToNextPage);
  }

  @override
  void initState() {
    super.initState();
    _initNotification();
    _startSplashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Text(
          'BaratieApp',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: greenSecondary),
        ),
      ),
    );
  }
}
