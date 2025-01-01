import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wanderwise/models/place.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern to ensure a single instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'itinerary.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the table for storing itineraries
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE itinerary(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        place_name TEXT,
        place_address TEXT,
        place_photo TEXT,
        rating REAL,
        user_ratings_total INTEGER,
        types TEXT,
        day_info TEXT
      )
    ''');
  }

  // Insert a new itinerary
  Future<void> insertItinerary(Place place, String dayInfo) async {
    final db = await database;

    // Flatten Place object and extract relevant information
    await db.insert(
      'itinerary',
      {
        'place_name': place.name,
        'place_address': place.vicinity,
        'place_photo': place.photos.isNotEmpty ? place.photos[0].photoReference : '', // Store photo reference URL
        'rating': place.rating,
        'user_ratings_total': place.userRatingsTotal,
        'types': place.types.join(','), // Store the types as a comma-separated string
        'day_info': dayInfo,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all itineraries
  Future<List<Map<String, dynamic>>> getItinerary() async {
    final db = await database;
    return await db.query('itinerary');
  }

  // Delete an itinerary
  Future<void> deleteItinerary(int id) async {
    final db = await database;
    await db.delete(
      'itinerary',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all itineraries (useful for reset or when app restarts)
  Future<void> clearAllItineraries() async {
    final db = await database;
    await db.delete('itinerary');
  }
}
