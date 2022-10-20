import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/response.dart';
import 'package:http/http.dart' as http;

void main() {
  group('Json Parse Test', () {
    test('should be able parse Json from response restaurant list', () async {
      http.Client client = MockClient((request) async {
        final file = File('test_resources/restaurant_list_response_test.json');
        final body = await file.readAsString();
        return http.Response(body, 200);
      });
      http.Response response = await client.get(Uri.parse('$baseUrl/list'));
      RestaurantListResponse restaurantListResponse =
          RestaurantListResponse.fromJson(json.decode(response.body));
      expect(restaurantListResponse.error, false);
    });

    test('should be able parse Json from response restaurant detail', () async {
      int id = 0;
      http.Client client = MockClient((request) async {
        final file =
            File('test_resources/restaurant_detail_response_test.json');
        final body = await file.readAsString();
        return http.Response(body, 200);
      });
      http.Response response =
          await client.get(Uri.parse('$baseUrl/detail/$id'));
      RestaurantDetailResponse restaurantListResponse =
          RestaurantDetailResponse.fromJson(json.decode(response.body));
      expect(restaurantListResponse.error, false);
    });
  });
}
