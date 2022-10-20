import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavourite = 'favourites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavourite (
             restaurantId TEXT PRIMARY KEY
            )
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavourite(String restaurantId) async {
    final db = await database;
    await db!.insert(_tblFavourite, {"restaurantId": restaurantId});
  }

  Future<List<String>> getFavourites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavourite);

    return results.map((res) => res["restaurantId"] as String).toList();
  }

  Future<Map> getFavouriteById(String restaurantId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavourite,
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavourite(String restaurantId) async {
    final db = await database;

    await db!.delete(
      _tblFavourite,
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );
  }
}
