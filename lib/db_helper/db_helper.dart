import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/place.dart';

class DatabaseHelper {
  // Singleton pattern for DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Database instance
  static Database? _database;

  // Private constructor
  DatabaseHelper._internal();

  // Get the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'trips.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trip_name TEXT,
        itinerary TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE fav_place (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        businessStatus TEXT,
        lat REAL,
        lng REAL,
        viewportNortheastLat REAL,
        viewportNortheastLng REAL,
        viewportSouthwestLat REAL,
        viewportSouthwestLng REAL,
        icon TEXT,
        iconBackgroundColor TEXT,
        iconMaskBaseUri TEXT,
        name TEXT,
        placeId TEXT,
        rating REAL,
        reference TEXT,
        scope TEXT,
        types TEXT,
        userRatingsTotal INTEGER,
        vicinity TEXT,
        photos TEXT
      )
    ''');
  }

  Future<void> addFavPlace(
      String businessStatus,
      double lat,
      double lng,
      double viewportNortheastLat,
      double viewportNortheastLng,
      double viewportSouthwestLat,
      double viewportSouthwestLng,
      String icon,
      String iconBackgroundColor,
      String iconMaskBaseUri,
      String name,
      String placeId,
      double rating,
      String reference,
      String scope,
      List<String> types,
      int userRatingsTotal,
      String vicinity,
      List<String> photos,
      ) async {
    final db = await database;

    Map<String, dynamic> favPlaceData = {
      'businessStatus': businessStatus,
      'lat': lat,
      'lng': lng,
      'viewportNortheastLat': viewportNortheastLat,
      'viewportNortheastLng': viewportNortheastLng,
      'viewportSouthwestLat': viewportSouthwestLat,
      'viewportSouthwestLng': viewportSouthwestLng,
      'icon': icon,
      'iconBackgroundColor': iconBackgroundColor,
      'iconMaskBaseUri': iconMaskBaseUri,
      'name': name,
      'placeId': placeId,
      'rating': rating,
      'reference': reference,
      'scope': scope,
      'types': types.join(','), // Convert list to a comma-separated string
      'userRatingsTotal': userRatingsTotal,
      'vicinity': vicinity,
      'photos': photos.join(','), // Convert list to a comma-separated string
    };

    await db.insert(
      'fav_place',
      favPlaceData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String,dynamic>>> getFavPlace() async {
    final db = await database;
    return await db.query('fav_place');
  }

  Future<void> deleteFav(int id) async {
    final db = await database;
    await db.delete('fav_place', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteTrip(int id) async {
    final db = await database;
    await db.delete('trips', where: 'id = ?', whereArgs: [id]);
  }

  // Update an article in the 'news' table
  Future<int> updateFav(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;
    return await db.update(
      'fav_place',
      updatedValues,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTrip(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;
    return await db.update(
      'trips',
      updatedValues,
      where: 'id = ?',
      whereArgs: [id],
    );

    print("Executing SQL update for trip ID: $id");

    // Map<String, dynamic> updatedTrip = {
    //   'trip_name': updatedValues['trip_name'],
    //   'itinerary': updatedValues['itinerary'],
    // };
    //
    // int result = await db.update(
    //   'trips',
    //   updatedTrip,
    //   where: 'id = ?',
    //   whereArgs: [id],
    // );

    // print("SQL Update result: $result");
    // return result;
  }

  // Save a trip to the database
  Future<void> saveTrip(String tripName, String itinerary) async {
    final db = await database;

    Map<String, dynamic> tripData = {
      'trip_name': tripName,
      'itinerary': itinerary,
    };

    print("Trip Data${tripData}");

    await db.insert(
      'trips',
      tripData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSavedTrips() async {
    final db = await database;
    return await db.query('trips');
  }

  // Get all trips from the database
  Future<List<Map<String, dynamic>>> getTrips() async {
    final db = await database;
    return await db.query('trips');
  }

  // Get a single trip by id
  Future<Map<String, dynamic>?> getTripById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'trips',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update a trip by id
  // Future<int> updateTrip(int id, Map<String, String> updatedValues) async {
  //   final db = await database;
  //
  //   Map<String, dynamic> updatedTrip = {
  //     'trip_name': tripName,
  //     'itinerary': itinerary,
  //   };
  //
  //   return await db.update(
  //     'trips',
  //     updatedTrip,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  // Delete a trip by id
  // Future<int> deleteTrip(int id) async {
  //   final db = await database;
  //   return await db.delete(
  //     'trips',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }
}
