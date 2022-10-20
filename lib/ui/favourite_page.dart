import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/response.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/home_provider.dart';
import 'package:restaurant_app/ui/widget/restaurant_item.dart';

class FavouritePage extends StatelessWidget {
  static const routeName = '/favourite';

  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 20,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            color: greenSecondary,
          ),
        ),
        elevation: 0,
        title: const Text(
          'Favourites',
        ),
      ),
      body: Consumer2<HomeProvider, DatabaseProvider>(
        builder: (context, homeProvider, dbProvider, _) {
          if (dbProvider.state == StateDP.loading ||
              homeProvider.state == StateHP.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (dbProvider.state == StateDP.hasData &&
              homeProvider.state == StateHP.hasData) {
            RestaurantListResponse response = homeProvider.restaurants;
            List<Restaurant> restaurants = response.restaurants
                .where((restaurant) =>
                    dbProvider.favourites.contains(restaurant.id))
                .toList();
            return ListView(
              children: restaurants.map((restaurant) {
                return RestaurantItem(restaurant: restaurant);
              }).toList(),
            );
          } else if (dbProvider.state == StateDP.noData ||
              homeProvider.state == StateHP.noData) {
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
                    'No favourites restaurant yet',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black12),
                  )
                ],
              ),
            );
          } else if (dbProvider.state == StateDP.error ||
              homeProvider.state == StateHP.error) {
            return Center(
                child: Text(
              homeProvider.message,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black12),
            ));
          } else {
            return Center(
              child: Text('${dbProvider.state} + ${homeProvider.state}'),
            );
          }
        },
      ),
    );
  }
}
