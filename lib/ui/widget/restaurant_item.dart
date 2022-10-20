import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItem({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Provider.of<RestaurantProvider>(context, listen: false)
                .fetchRestaurantDetail(restaurant.id);

            Navigator.pushNamed(context, RestaurantDetailPage.routeName,
                arguments: restaurant.id);
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: restaurant.pictureId,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      '$baseUrl/images/small/${restaurant.pictureId}',
                      height: 100,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            size: 20,
                            color: Color(0xff6ccc2c),
                          ),
                          Expanded(
                            child: Text(restaurant.city),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 20,
                            color: Color(0xfffa8c0a),
                          ),
                          Expanded(
                            child: Text(restaurant.rating.toString()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Consumer<DatabaseProvider>(
                      builder: (context, provider, _) {
                        return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.all(10),
                            minimumSize: Size.zero,
                            side: const BorderSide(
                                width: 1, color: Colors.black12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                                )
                              : const Icon(
                                  EvaIcons.heartOutline,
                                  color: Colors.black38,
                                ),
                        );
                      },
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Icon(
                        FeatherIcons.share2,
                        color: Colors.black38,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
