import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';
import '../../db_helper/db_helper.dart';
import 'saved_itinerary_details_screen.dart';

class SavedItineraryScreen extends StatefulWidget {
  @override
  _SavedItineraryScreenState createState() => _SavedItineraryScreenState();
}

class _SavedItineraryScreenState extends State<SavedItineraryScreen> {
  final savedTrips = <Map<String, dynamic>>[].obs; // Reactive list for saved trips

  @override
  void initState() {
    super.initState();
    _fetchSavedTrips();
  }

  Future<void> _fetchSavedTrips() async {
    try {
      final dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> trips = await dbHelper.getSavedTrips();
      savedTrips.assignAll(trips); // Update reactive list
    } catch (e) {
      print("Error fetching trips: $e");
    }
  }

  Future<void> _deleteTrip(int id) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteTrip(id);

      // Remove trip from the reactive list
      savedTrips.removeWhere((trip) => trip['id'] == id);

      Get.snackbar(
        'Success',
        'Trip deleted!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      print("Error deleting trip: $e");
      Get.snackbar(
        'Error',
        'Failed to delete trip!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );

      // Optionally refresh trips in case of an error
      _fetchSavedTrips();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Trips",
          style: TextStyle(
            color: themeController.isDarkMode.value ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
        ),
      ),
      body: Obx(() => savedTrips.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              "No saved trips...",
              style: TextStyle(
                fontSize: 16,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: savedTrips.length,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemBuilder: (context, index) {
          final trip = savedTrips[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: themeController.isDarkMode.value
                    ? Colors.grey[800]
                    : Colors.grey[200],
                child: Icon(
                  Icons.flight_takeoff,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              title: Text(
                trip['trip_name'] ?? 'Unnamed Trip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => _deleteTrip(trip['id']),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ],
              ),
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedItineraryDetailsScreen(
                      tripName: trip['trip_name'],
                      itinerary: trip['itinerary'],
                      tripID: trip['id'],
                    ),
                  ),
                );

                // If the trip was updated, refresh the list
                if (updated == true) {
                  _fetchSavedTrips();
                }
              },
            ),
          );
        },
      )),
    );
  }
}
