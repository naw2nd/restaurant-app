import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/response.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/widget/add_review.dart';

class CustomerReviewPage extends StatelessWidget {
  static String routeName = '/reviews';

  final String restaurantId;

  const CustomerReviewPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Review',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: primaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, value, child) {
          if (value.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (value.state == ResultState.hasData) {
            RestaurantDetailResponse response = value.restaurant;
            return ListView(
              children: response.restaurant.customerReviews
                  .map(
                    (review) => ListTile(
                      horizontalTitleGap: 15,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      leading: const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Colors.black12,
                      ),
                      dense: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(review.name, overflow: TextOverflow.ellipsis,)),
                          Text(
                            review.date,
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(review.review),
                    ),
                  )
                  .toList(),
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
                    'There is no customer review yet',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black12),
                  )
                ],
              ),
            );
          } else if (value.state == ResultState.error) {
            return Center(
              child: Material(
                child: Text(value.message),
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: Center(
            child: Icon(
              Icons.add_rounded,
              color: greenSecondary,
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: AddReview(
                  restaurantId: restaurantId,
                ),
              ),
            );
          }),
    );
  }
}
