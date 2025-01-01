import 'package:flutter/material.dart';
import 'package:wanderwise/app/saved/saved_itinerary_details_screen.dart';
import '../../db_helper/db_helper.dart'; // Make sure this path is correct

class SavedItineraryScreen extends StatefulWidget {
  @override
  _SavedItineraryScreenState createState() => _SavedItineraryScreenState();
}

class _SavedItineraryScreenState extends State<SavedItineraryScreen> {
  List<Map<String, dynamic>> savedTrips = [];

  @override
  void initState() {
    super.initState();
    _fetchSavedTrips(); // Fetch trips when the screen is first loaded
  }

  // Method to fetch saved trips from the database
  Future<void> _fetchSavedTrips() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    try {
      // Assuming there's a method `getSavedTrips()` in the dbHelper
      List<Map<String, dynamic>> trips = await dbHelper.getSavedTrips();
      setState(() {
        savedTrips = trips; // Update the state with the fetched trips
      });
    } catch (e) {
      print("Error fetching trips: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Trips"),
        backgroundColor: Colors.black,
      ),
      body: savedTrips.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching trips
          : ListView.builder(
        itemCount: savedTrips.length,
        itemBuilder: (context, index) {
          final trip = savedTrips[index];
          // Assuming trip contains 'name' as a string and other trip-related details
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(trip['name'] ?? 'Unnamed Trip'),
              subtitle: Text('Tap to view details'), // You can change this based on your data
              onTap: () {
                // Navigate to the TripDetailPage and pass the tripId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedItineraryDetailsScreen(tripId: trip['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
