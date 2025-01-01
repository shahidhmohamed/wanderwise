import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Get the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Create a new database if one does not exist
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'places_itinerary.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY,
        name TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE places (
        id INTEGER PRIMARY KEY,
        name TEXT,
        rating REAL
      );
    ''');

    await db.execute('''
      CREATE TABLE itinerary (
        id INTEGER PRIMARY KEY,
        trip_id INTEGER,  -- Foreign key reference to the trips table
        day TEXT,
        FOREIGN KEY(trip_id) REFERENCES trips(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE trip_activities (
        id INTEGER PRIMARY KEY,
        itinerary_id INTEGER,  -- Foreign key to itinerary
        place_id INTEGER,  -- Foreign key to places
        FOREIGN KEY(itinerary_id) REFERENCES itinerary(id),
        FOREIGN KEY(place_id) REFERENCES places(id)
      );
    ''');
  }

  // Insert trip data into the database
  Future<int> _insertTrip(String tripName, Database db) async {
    return await db.insert(
      'trips',
      {'name': tripName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert place data into the database
  Future<int> _insertPlace(Map<String, dynamic> place, Database db) async {
    return await db.insert(
      'places',
      place,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert itinerary data into the database
  Future<int> _insertItinerary(int tripId, String day, Database db) async {
    return await db.insert(
      'itinerary',
      {'trip_id': tripId, 'day': day},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertTripActivity(int itineraryId, int placeId, Database db) async {
    await db.insert(
      'trip_activities',
      {'itinerary_id': itineraryId, 'place_id': placeId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Save a full trip with places and itinerary
  Future<void> saveTrip(String tripName, List<Map<String, dynamic>> places, List<Map<String, dynamic>> itinerary) async {
    final db = await database;

    // 1. Insert the trip record
    int tripId = await _insertTrip(tripName, db);

    // 2. Insert places into the database and collect place IDs
    List<int> placeIds = [];
    for (var place in places) {
      int placeId = await _insertPlace(place, db);
      placeIds.add(placeId);
    }

    // 3. Insert itinerary days and link them to the trip
    for (var day in itinerary) {
      int itineraryId = await _insertItinerary(tripId, day['day'], db);

      // 4. Link places to the itinerary days by matching activity names to place names
      List<String> activities = day['activities'];  // List of activity names
      for (var activity in activities) {
        // Find the corresponding placeId by matching name with the places list
        int placeId = places.indexWhere((place) => place['name'] == activity); // Find place by name

        if (placeId != -1) {
          await _insertTripActivity(itineraryId, placeId, db);  // Link place to day
        } else {
          print('Place for activity "$activity" not found.');
        }
      }
    }

    print("Trip saved successfully!");
  }

  Future<List<Map<String, dynamic>>> getSavedTrips() async {
    final db = await database; // Get a reference to your database (assuming it's initialized)

    // Query your database for all saved trips
    final List<Map<String, dynamic>> trips = await db.query('trips'); // Assuming 'trips' is the table name
    return trips;
  }
}
