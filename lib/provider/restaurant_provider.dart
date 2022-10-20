import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/data/model/response.dart';

enum StateRP { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  late RestaurantDetailResponse _restaurant;
  late StateRP _state;
  late CustomerReviewResponse _customerReview;
  String _message = '';

  RestaurantProvider({required this.apiService});

  String get message => _message;
  RestaurantDetailResponse get restaurant => _restaurant;
  CustomerReviewResponse get customerReview => _customerReview;
  StateRP get state => _state;

  Future<dynamic> fetchRestaurantDetail(String id) async {
    try {
      _state = StateRP.loading;
      notifyListeners();

      final response = await apiService.getRestaurantDetail(id);
      _state = StateRP.hasData;
      notifyListeners();
      return _restaurant = response;
    } catch (e) {
      _state = StateRP.error;
      notifyListeners();
      return _message = 'Failed to load restaurant';
    }
  }

  Future<dynamic> addUserReview(
      CustomerReview customerReview, String restaurantId) async {
    try {
      _state = StateRP.loading;
      notifyListeners();
      final response =
          await apiService.postUserReview(customerReview, restaurantId);
      _state = StateRP.hasData;
      notifyListeners();
      return _restaurant.restaurant.customerReviews = response.customerReviews;
    } catch (e) {
      _state = StateRP.error;
      notifyListeners();
      return _message = 'Failed to load review';
    }
  }
}
