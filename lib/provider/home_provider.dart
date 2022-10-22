import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/response.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

enum StateHP { loading, noData, hasData, error }

class HomeProvider extends ChangeNotifier {
  final ApiService apiService;
  late RestaurantDetailResponse _restaurant;
  late RestaurantListResponse _restaurantsResponse;
  late StateHP _state;
  late CustomerReviewResponse _customerReviewResponse;
  String _message = '';

  HomeProvider({required this.apiService}) {
    fetchAllRestaurant('');
  }

  String get message => _message;
  RestaurantDetailResponse get restaurant => _restaurant;
  RestaurantListResponse get restaurants => _restaurantsResponse;
  CustomerReviewResponse get customerReview => _customerReviewResponse;
  StateHP get state => _state;

  Future<dynamic> fetchAllRestaurant(String query) async {
    try {
      _state = StateHP.loading;
      RestaurantListResponse response;
      notifyListeners();
      if (query.isEmpty || query == '') {
        response = await apiService.getListRestaurant();
      } else {
        response = await apiService.getSearchedRestaurant(query);
      }
      if (response.restaurants.isEmpty) {
        _state = StateHP.noData;
        notifyListeners();
        return _message = 'No Restaurant Available';
      } else {
        _state = StateHP.hasData;
        notifyListeners();
        return _restaurantsResponse = response;
      }
    } catch (e) {
      _state = StateHP.error;
      notifyListeners();
      return _message = 'Failed to load restaurant';
    }
  }

  int _next(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }

  Future<dynamic> getPromotedRestaurant() async {
    try {
      RestaurantListResponse response =  await fetchAllRestaurant('');
      List<Restaurant> listRestaurant = response.restaurants;
      Restaurant promotedRestaurant =
          listRestaurant[_next(0, listRestaurant.length - 1)];
      _state = StateHP.hasData;
      notifyListeners();
      return promotedRestaurant;
    } catch (e) {
      _state = StateHP.error;
      notifyListeners();
      return _message = 'Failed to load restaurant';
    }
  }
}
