import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/data/model/response.dart';

const String baseUrl = 'https://restaurant-api.dicoding.dev';

class ApiService {
  Future<RestaurantListResponse> getListRestaurant() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<RestaurantListResponse> getSearchedRestaurant(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<CustomerReviewResponse> postUserReview(
      CustomerReview customerReview, String restaurantId) async {
    final response = await http.post(Uri.parse('$baseUrl/review'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": restaurantId,
          "name": customerReview.name,
          "review": customerReview.review
        }));

    if (response.statusCode == 201) {

      return CustomerReviewResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
