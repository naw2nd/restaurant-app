import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/drink.dart';
import 'package:restaurant_app/data/model/food.dart';
import 'package:restaurant_app/data/model/response.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/customer_review_page.dart';
import 'package:restaurant_app/utils/sliver_appbar_delegate.dart';

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
  final _scrollDescriptionController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(builder: (context, value, _) {
      if (value.state == ResultState.loading) {
        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      } else if (value.state == ResultState.hasData) {
        RestaurantDetailResponse response = value.restaurant;
        RestaurantDetail restaurant = response.restaurant;
        return Stack(
          children: [
            Column(
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
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Container(
              height: 300,
              color: Colors.black26,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: _buildMainAppBar(context),
              body: _buildMainBody(context, restaurant),
            ),
          ],
        );
      } else if (value.state == ResultState.noData) {
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
      } else if (value.state == ResultState.error) {
        return Scaffold(
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

  AppBar _buildMainAppBar(BuildContext context) {
    return AppBar(
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: SizedBox(
          height: 20,
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: const Icon(
                FeatherIcons.chevronLeft,
                size: 25,
              ),
            ),
          ),
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white60,
                  shape: const CircleBorder(),
                ),
                onPressed: () {},
                child: const Icon(
                  FeatherIcons.share2,
                  size: 25,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white60,
                  shape: const CircleBorder(),
                ),
                onPressed: () {},
                child: const Icon(
                  FeatherIcons.heart,
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  NestedScrollView _buildMainBody(
      BuildContext context, RestaurantDetail restaurant) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          const SliverAppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            expandedHeight: 150,
          )
        ];
      },
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: 200,
              maxHeight: 280,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _buildMainContent(context, restaurant),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            sliver: SliverGrid.count(
              childAspectRatio: 0.7,
              crossAxisSpacing: 30,
              crossAxisCount: 2,
              children: _selectedMenuType == 'foods'
                  ? restaurant.menu.foods.map(_buildTile).toList()
                  : restaurant.menu.drinks.map(_buildTile).toList(),
            ),
          )
        ],
      ),
    );
  }

  Column _buildMainContent(BuildContext context, RestaurantDetail restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Center(
          child: Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(5)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        const Icon(
                          Icons.location_pin,
                          size: 20,
                          color: Color(0xff6ccc2c),
                        ),
                        Text(restaurant.city),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  side: const BorderSide(color: Colors.black26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    CustomerReviewPage.routeName,
                    arguments: restaurant.id,
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 30,
                      color: Color(0xfffa8c0a),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${restaurant.rating}',
                        ),
                        Text(
                          'rating',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(color: Colors.grey),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollDescriptionController,
              child: SingleChildScrollView(
                controller: _scrollDescriptionController,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    restaurant.description,
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(color: Colors.grey),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(
                width: 30,
              ),
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
      ],
    );
  }

  Widget _buildTile(var menuItem) {
    if (_selectedMenuType == 'drinks') {
      menuItem = menuItem as Drink;
    } else {
      menuItem = menuItem as Food;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.black12),
            child: const Icon(
              EvaIcons.image,
              color: Colors.black12,
              size: 70,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Flexible(
          child: Text(
            menuItem.name,
            style: Theme.of(context).textTheme.subtitle2,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
