import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

abstract class Response {
  bool error;
  String message;

  Response({required this.error, required this.message});
}

class RestaurantListResponse extends Response {
  RestaurantListResponse({
    required super.error,
    required super.message,
    required this.count,
    required this.restaurants,
  });

  int count;
  List<Restaurant> restaurants;

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantListResponse(
        error: json["error"],
        message: json["message"] ?? '',
        count: json["count"] ?? json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class RestaurantDetailResponse extends Response {
  RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required super.error,
    required super.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json["error"],
      message: json["message"],
      restaurant: RestaurantDetail.fromJson(json["restaurant"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}

class CustomerReviewResponse extends Response {
  List<CustomerReview> customerReviews;
  CustomerReviewResponse({
    required super.error,
    required super.message,
    required this.customerReviews,
  });

  factory CustomerReviewResponse.fromJson(Map<String, dynamic> json) =>
      CustomerReviewResponse(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
}
