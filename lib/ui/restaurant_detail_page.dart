import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/response.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/customer_review_page.dart';
import 'package:restaurant_app/ui/widget/menu_item.dart';
import 'package:sliver_tools/sliver_tools.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String restaurantId;

  const RestaurantDetailPage({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  String _selectedMenuType = 'foods';

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(builder: (context, value, _) {
      if (value.state == StateRP.loading) {
        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      } else if (value.state == StateRP.hasData) {
        RestaurantDetailResponse response = value.restaurant;
        RestaurantDetail restaurant = response.restaurant;
        return Stack(
          children: [
            SizedBox(
              height: 300,
              child: Hero(
                tag: restaurant.pictureId,
                child: Image.network(
                  '$baseUrl/images/large/${restaurant.pictureId}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 300,
              color: Colors.black26,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                titleSpacing: 5,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white60,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        FeatherIcons.chevronLeft,
                        size: 27,
                      ),
                    ),
                    Consumer<DatabaseProvider>(builder: (context, provider, _) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white60,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () async {
                          bool isLiked =
                              await provider.isFavourited(restaurant.id);
                          if (!isLiked) {
                            provider.addFavourite(restaurant.id);
                          } else {
                            provider.removeFavourite(restaurant.id);
                          }
                        },
                        child: provider.favourites.contains(restaurant.id)
                            ? const Icon(
                                EvaIcons.heart,
                                color: Color(0xffdc1339),
                                size: 27,
                              )
                            : const Icon(
                                EvaIcons.heartOutline,
                                color: Colors.black38,
                                size: 27,
                              ),
                      );
                    }),
                  ],
                ),
              ),
              body: Container(
                margin: const EdgeInsets.only(top: 150),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _buildMainBody(restaurant, context),
              ),
            ),
          ],
        );
      } else if (value.state == StateRP.error) {
        return Scaffold(
            appBar: AppBar(
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
                'Restaurant Detail',
              ),
            ),
            body: Center(
                child: Text(
              value.message,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black12),
            )));
      } else {
        return Scaffold(
          body: Container(),
        );
      }
    });
  }

  CustomScrollView _buildMainBody(
      RestaurantDetail restaurant, BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPinnedHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    Text(
                      restaurant.name,
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              CustomerReviewPage.routeName,
                              arguments: restaurant.id,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: Color(0xfffa8c0a),
                                ),
                                Text(
                                  '${restaurant.rating} rating ',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.location_pin,
                          size: 20,
                          color: Color(0xff6ccc2c),
                        ),
                        Flexible(child: Text(restaurant.city)),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                color: Colors.white,
                child: Text(
                  restaurant.description,
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.justify,
                ),
              ),
              const Divider(color: Colors.grey),
            ],
          ),
        ),
        SliverPinnedHeader(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedMenuType = 'foods';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: _selectedMenuType == 'foods'
                            ? Colors.black87
                            : Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Foods',
                    style: TextStyle(
                        color: _selectedMenuType == 'foods'
                            ? Colors.black87
                            : Colors.black45),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedMenuType = 'drinks';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: _selectedMenuType == 'drinks'
                            ? Colors.black87
                            : Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Drinks',
                    style: TextStyle(
                        color: _selectedMenuType == 'drinks'
                            ? Colors.black87
                            : Colors.black45),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverGrid.count(
          childAspectRatio: 0.7,
          crossAxisSpacing: 30,
          crossAxisCount: 2,
          children: _selectedMenuType == 'foods'
              ? restaurant.menu.foods
                  .map((food) => RestaurantMenuItem(
                        menuItem: food,
                      ))
                  .toList()
              : restaurant.menu.drinks
                  .map((drink) => RestaurantMenuItem(
                        menuItem: drink,
                      ))
                  .toList(),
        ),
      ],
    );
  }
}
