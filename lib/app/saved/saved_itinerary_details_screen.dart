import 'package:flutter/material.dart';
import '../../db_helper/db_helper.dart';

class SavedItineraryDetailsScreen extends StatefulWidget {
  final int tripId; // Pass the tripId from the previous page

  SavedItineraryDetailsScreen({required this.tripId}); // Constructor to receive the tripId

  @override
  _SavedItineraryDetailsScreenState createState() => _SavedItineraryDetailsScreenState();
}

class _SavedItineraryDetailsScreenState extends State<SavedItineraryDetailsScreen> {
  late Future<Map<String, dynamic>> _tripDetailsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the trip details when the page is loaded
    _tripDetailsFuture = _fetchTripDetails(widget.tripId);
  }

  // Method to fetch the detailed trip data from the database
  Future<Map<String, dynamic>> _fetchTripDetails(int tripId) async {
    final db = await DatabaseHelper().database;

    // Fetch the basic trip info (name)
    final tripResult = await db.query('trips', where: 'id = ?', whereArgs: [tripId]);
    final trip = tripResult.first;

    // Fetch the itinerary (days) for the trip
    final itineraryResult = await db.query('itinerary', where: 'trip_id = ?', whereArgs: [tripId]);

    // Fetch the places and activities related to the trip's itinerary
    final tripActivitiesResult = await db.rawQuery('''
      SELECT places.name AS place_name, itinerary.day, places.rating
      FROM trip_activities
      JOIN places ON trip_activities.place_id = places.id
      JOIN itinerary ON trip_activities.itinerary_id = itinerary.id
      WHERE itinerary.trip_id = ?
    ''', [tripId]);

    return {
      'trip': trip,
      'itinerary': itineraryResult,
      'activities': tripActivitiesResult,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Details"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _tripDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching data
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Show error if any
          }

          if (!snapshot.hasData || snapshot.data!['trip'] == null) {
            return Center(child: Text('No data found.'));
          }

          final trip = snapshot.data!['trip'];
          final itinerary = snapshot.data!['itinerary'];
          final activities = snapshot.data!['activities'];

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Itinerary:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...itinerary.map<Widget>((day) {
                  return ListTile(
                    title: Text('Day: ${day['day']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Activities:'),
                        ...activities.where((activity) =>
                        activity['day'] == day['day']).map<Widget>((activity) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              '${activity['place_name']} - Rating: ${activity['rating']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
