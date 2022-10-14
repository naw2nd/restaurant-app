import 'dart:convert';

import 'menu.dart';

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menu,
  });

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  Menu menu;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
        menu: Menu.fromJson(json["menus"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
        "menus": menu.toJson(),
      };

  
}

List<Restaurant> parseRestaurant(String? json) {

  if (json == null) {
    return [];
  }

  var decodedJson = jsonDecode(json);

  final List parsed = decodedJson["restaurants"];

  return parsed.map((json) => Restaurant.fromJson(json)).toList();
}




