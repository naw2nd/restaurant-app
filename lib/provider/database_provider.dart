import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/db/database_helper.dart';

enum StateDP { loading, noData, hasData, error }

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavourites();
  }

  late StateDP _state;
  StateDP get state => _state;

  String _message = '';
  String get message => _message;

  List<String> _favourites = [];
  List<String> get favourites => _favourites;

  bool _isFavourite = false;
  bool get isFavourite => _isFavourite;

  void _getFavourites() async {
    try {
      _state = StateDP.loading;
      _favourites = await databaseHelper.getFavourites();
      notifyListeners();
      if (_favourites.isNotEmpty) {
        _state = StateDP.hasData;
        notifyListeners();
      } else {
        _state = StateDP.noData;
        _message = 'Empty Data';
        notifyListeners();
      }
    } on Exception catch (e) {
      _state = StateDP.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void addFavourite(String restaurantId) async {
    try {
      _state = StateDP.loading;
      await databaseHelper.insertFavourite(restaurantId);
      _getFavourites();
    } on Exception catch (e) {
      _state = StateDP.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavourited(String restaurantId) async {
    try {
      _state = StateDP.loading;
      final favourited = await databaseHelper.getFavouriteById(restaurantId);
      _state = StateDP.hasData;
      return _isFavourite = favourited.isNotEmpty;
    } on Exception catch (e) {
      _state = StateDP.error;
      _message = 'Error: $e';
      return false;
    }
  }

  void removeFavourite(String restaurantId) async {
    try {
      _state = StateDP.loading;
      await databaseHelper.removeFavourite(restaurantId);
      _getFavourites();
    } catch (e) {
      _state = StateDP.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
