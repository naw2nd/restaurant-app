import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/data/model/response.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  late RestaurantDetailResponse _restaurant;
  late RestaurantListResponse _restaurants;
  late ResultState _state;
  late CustomerReviewResponse _customerReview;
  String _message = '';

  RestaurantProvider({required this.apiService}) {
    print('const');
    fetchAllRestaurant();
  }

  String get message => _message;
  RestaurantDetailResponse get restaurant => _restaurant;
  RestaurantListResponse get restaurants => _restaurants;
  CustomerReviewResponse get customerReview => _customerReview;
  ResultState get state => _state;

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.getListRestaurant();
      if (response.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Restaurant Available';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurants = response;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load restaurant';
    }
  }

  Future<dynamic> fetchSearchedRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.getSearchedRestaurant(query);
      if (response.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Restaurant Available';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurants = response;
      }
    } catch (e) {
      _state = ResultState.error;

      notifyListeners();
      return _message = 'Failed to load restaurant';
    }
  }

  Future<dynamic> fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.getRestaurantDetail(id);
      _state = ResultState.hasData;
      notifyListeners();
      return _restaurant = response;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load restaurant';
    }
  }

  Future<dynamic> addUserReview(
      CustomerReview customerReview, String restaurantId) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response =
          await apiService.postUserReview(customerReview, restaurantId);
      _state = ResultState.hasData;
      notifyListeners();
      return _restaurant.restaurant.customerReviews = response.customerReviews;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load review';
    }
  }
}
