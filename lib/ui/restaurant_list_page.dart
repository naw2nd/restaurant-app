import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/received_notification.dart';
import 'package:restaurant_app/data/model/response.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/provider/home_provider.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart' as rp;
import 'package:restaurant_app/ui/favourite_page.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/widget/restaurant_item.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/utils/schedule_service.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final TextEditingController _tecSearch = TextEditingController();
  @override
  void initState() {
    _configureSelectNotificationSubject();
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    _tecSearch.dispose();
    super.dispose();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      Provider.of<rp.RestaurantProvider>(context, listen: false)
          .fetchRestaurantDetail(payload ?? '');
      Navigator.pushNamed(context, RestaurantDetailPage.routeName,
          arguments: payload);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text('BaratieApp'),
        actions: [
          Consumer<PreferencesProvider>(builder: (context, provider, _) {
            return IconButton(
              onPressed: () async {
                bool scheduled = await scheduleReminder(provider, context);
                
                if (scheduled) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(
                        'Notification turned ${provider.reminder == true ? 'on, daily at 11 AM' : 'off'}'),
                  ));
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                          'Cannot set notification while device not connected to internet')));
                }
              },
              icon: Icon(
                provider.reminder == true
                    ? EvaIcons.bell
                    : EvaIcons.bellOffOutline,
                color: greenSecondary,
              ),
            );
          }),
          IconButton(
            onPressed: () {
              Provider.of<HomeProvider>(context, listen: false)
                  .fetchAllRestaurant('');
              Navigator.pushNamed(context, FavouritePage.routeName);
            },
            icon: Icon(
              EvaIcons.heart,
              color: greenSecondary,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 00),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: 40,
                      color: primaryColor,
                    ),
                    Container(
                      height: 40,
                      color: baseColor,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _tecSearch,
                    style: const TextStyle(color: Colors.black38),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Search for something tasty...',
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(
                        FeatherIcons.search,
                        color: Colors.black38,
                      ),
                    ),
                    onChanged: (value) {
                      Provider.of<HomeProvider>(context, listen: false)
                          .fetchAllRestaurant(value);
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              color: baseColor,
              child: Text(
                'Recomended for you',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: _buildRestaurantList(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> scheduleReminder(
      PreferencesProvider provider, BuildContext context) async {
    // provider.setReminder(!provider.reminder);
    _tecSearch.clear();
    ScheduleService scheduleService = ScheduleService();
    if (provider.reminder == false) {
      HomeProvider providerHome =
          Provider.of<HomeProvider>(context, listen: false);
      dynamic restaurant =
          await Provider.of<HomeProvider>(context, listen: false)
              .getPromotedRestaurant();
      if (providerHome.state == StateHP.hasData) {
        ReceivedNotification notification = ReceivedNotification(
            title: 'Promo in ${restaurant.city} City',
            body: 'Restaurant ${restaurant.name}',
            payload: restaurant.id);
        int dailyNotificationHour = 11;
        scheduleService.scheduleDailyNotification(
            dailyNotificationHour, notification);

        provider.setReminder(true);
        return true;
      } else {
        provider.setReminder(false);
        return false;
      }
    } else {
      provider.setReminder(false);
      scheduleService.cancelAllSceduledNotification();
      return true;
    }
  }

  Widget _buildRestaurantList(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, _) {
        if (value.state == StateHP.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (value.state == StateHP.hasData) {
          RestaurantListResponse response = value.restaurants;
          return ListView(
            children: response.restaurants
                .map((restaurant) => RestaurantItem(restaurant: restaurant))
                .toList(),
          );
        } else if (value.state == StateHP.noData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.store_rounded,
                  color: Colors.black12,
                  size: 100,
                ),
                Text(
                  'Sorry, we cant find your restaurant..',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black12),
                )
              ],
            ),
          );
        } else if (value.state == StateHP.error) {
          return Center(
              child: Text(
            value.message,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.black12),
          ));
        } else {
          return const Center(
            child: Text(''),
          );
        }
      },
    );
  }
}
