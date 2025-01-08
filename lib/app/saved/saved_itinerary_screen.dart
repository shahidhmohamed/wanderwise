import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wanderwise/app/favorite/favorite_screen.dart';
import '../../controllers/theme_controller.dart';
import '../../db_helper/db_helper.dart';
import 'saved_itinerary_details_screen.dart';

class SavedItineraryScreen extends StatefulWidget {
  @override
  _SavedItineraryScreenState createState() => _SavedItineraryScreenState();
}

class _SavedItineraryScreenState extends State<SavedItineraryScreen> {
  final savedTrips = <Map<String, dynamic>>[].obs;
  bool haveInternetConnection = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _fetchSavedTrips();
  }

  Future<void> _checkInternetConnection() async {
    bool isConnected = await hasInternetConnection();
    setState(() {
      haveInternetConnection = !isConnected;
    });
  }

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No connectivity
    }
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false; // Unable to reach the internet
    }
  }

  final List<Map<String, dynamic>> dummyTrips = [
    {
      'id': 1,
      'trip_name': 'Beach Adventure',
      'itinerary': 'Day 1: Relax at the beach\nDay 2: Snorkeling\nDay 3: Sunset Cruise',
    },
    {
      'id': 2,
      'trip_name': 'Mountain Expedition',
      'itinerary': 'Day 1: Trek to base camp\nDay 2: Climb the summit\nDay 3: Descend and relax',
    },
    {
      'id': 3,
      'trip_name': 'City Exploration',
      'itinerary': 'Day 1: Visit museums\nDay 2: Food tour\nDay 3: Shopping spree',
    },
  ];


  Future<void> _fetchSavedTrips() async {
    try {
      final dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> trips = await dbHelper.getSavedTrips();
      savedTrips.assignAll(trips);
    } catch (e) {
      print("Error fetching trips: $e");
    }
  }

  Future<void> _deleteTrip(int id) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteTrip(id);

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
            color:
                themeController.isDarkMode.value ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          if (haveInternetConnection)
            IconButton(
              onPressed: () {
                Get.to(() => FavoritesScreen());
              },
              icon: Icon(
                Icons.place_outlined,
                size: 40,
              ),
              color: themeController.isDarkMode.value
                  ? Colors.white
                  : Colors.black,
            ),
        ],
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
