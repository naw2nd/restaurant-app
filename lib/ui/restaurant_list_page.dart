import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/styles.dart';
import 'package:restaurant_app/ui/widget/restaurant_item.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = 'restaurant_list';

  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final TextEditingController _tecSearch = TextEditingController();
  String _searchValue = '';

  @override
  void dispose() {
    _tecSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text('BaratieApp'),
        actions: [
          Center(
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(right: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: greenSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        FeatherIcons.shoppingCart,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '0',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                      setState(() {
                        _searchValue = value.toLowerCase();
                      });
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

  FutureBuilder<String> _buildRestaurantList(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/json/local_restaurant.json'),
      builder: (context, snapshot) {
        List<Restaurant> restaurants = parseRestaurant(snapshot.data);
        if (restaurants.isEmpty) {
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
        }
        List<Restaurant> filteredRestaurant = [];
        if (_searchValue != '') {
          for (Restaurant restaurant in restaurants) {
            if (restaurant.name.toLowerCase().contains(_searchValue)) {
              filteredRestaurant.add(restaurant);
            }
          }
          restaurants = filteredRestaurant;
        }

        return ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return RestaurantItem(restaurant: restaurants[index]);
          },
        );
      },
    );
  }
}
