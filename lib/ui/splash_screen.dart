import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/ui/restaurant_list_page.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigationToNextPage() {
    Navigator.pushReplacementNamed(context, RestaurantListPage.routeName);
  }

  startSplashScreenTimer() async {
    print('screen');
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationToNextPage);
  }

  @override
  void initState() {
    super.initState();
    startSplashScreenTimer();
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

