import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wanderwise/app/explore/view_details.dart';
import 'dart:ui'; // Import for BackdropFilter
import '../../controllers/theme_controller.dart';
import '../../db_helper/db_helper.dart';
import '../../models/place.dart';
import '../../widgets/TimeLineTileUI.dart';
import '../../widgets/dotbar_widget_2.dart';
import 'package:get/get.dart';

class ItineraryScreen extends StatelessWidget {
  final List<Place> places;
  final List<String> itinerary;

  const ItineraryScreen({super.key, required this.places, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          title: Center(
            child: Text(
              'Plan Your Trip',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                // Prompt the user to input the trip name
                String? tripName = await _showTripNameDialog(context);

                if (tripName != null && tripName.isNotEmpty) {
                  print("Places: $places");
                  print("Itinerary: $itinerary");

                  // Convert List<Place> to List<Map<String, dynamic>> for the database
                  List<Map<String, dynamic>> placesMap = places.map((place) {
                    return {
                      'name': place.name,
                      'rating': place.rating,
                    };
                  }).toList();

                  // Parse itinerary into a map where the key is the day (Day 1, Day 2, etc.) and the value is a list of places
                  Map<String, List<String>> itineraryMap = {};

                  for (String dayInfo in itinerary) {
                    var parts = dayInfo.split(' - Suggested Activities: ');
                    if (parts.length == 2) {
                      String day = parts[0];  // Day 1, Day 2, etc.
                      List<String> activities = parts[1]
                          .split(', ')  // Split by commas to get each activity
                          .map((activity) => activity.split(' (Rating: ')[0].trim())  // Remove rating part
                          .toList();

                      itineraryMap[day] = activities;
                    }
                  }

                  // Convert itineraryMap into a List<Map<String, dynamic>> for the database
                  List<Map<String, dynamic>> itineraryDbMap = [];
                  itineraryMap.forEach((day, activities) {
                    itineraryDbMap.add({
                      'day': day,
                      'activities': activities,  // This will store the list of activity names
                    });
                  });

                  // Save the trip with places and itinerary using DatabaseHelper
                  final dbHelper = DatabaseHelper();
                  await dbHelper.saveTrip(tripName, placesMap, itineraryDbMap);

                  // Optionally, show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip saved successfully!')));
                } else {
                  // Handle the case where the user cancels or leaves the name empty
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip name is required!')));
                }
              },
              child: Icon(
                FontAwesomeIcons.download,
                color: themeController.isDarkMode.value ? Colors.white : Colors.blue,
              ),
            ),
          ],
          elevation: 0, // Remove shadow for a cleaner look
        ),

        body: ListView.builder(
        itemCount: itinerary.length,
        itemBuilder: (context, index) {
          final dayInfo = itinerary[index];
          final place = places[index];

          return GestureDetector(
            onTap: () {
              // Navigate to the ViewPlacePage when the card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPlacePage(article: place, dayInfo: dayInfo),
                ),
              );
            },
            child: TimeLineTileUI(
              isFirst: index == 0,
              isLast: index == itinerary.length - 1,
              isPast: index < DateTime.now().day, // You can modify this logic based on the current day
              eventChild: Stack(
                children: [
                  // Background image wrapped in BackdropFilter for blur effect
                  if (place.photos.isNotEmpty)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners for the image
                        child: BackdropFilter(
                          filter: ImageFilter.blur(), // Apply blur effect
                          child: Image.network(
                            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place.photos[0].photoReference}&key=AIzaSyB5zxGGP_ydXAdIptfpjGdmcEEs_i42_KU',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  // Content on top of the blurred background image
                  Positioned(
                    bottom: 70, // Adjust the position as needed
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 28),
                        Center(
                          child: Text(
                            place.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Rating: ${place.rating}',
                            style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 6),
                        Center(
                          child: DotBar(rating: place.rating),
                        ),
                        SizedBox(height: 8),
                        // Text(dayInfo, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        },
      ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     // Prompt the user to input the trip name
        //     String? tripName = await _showTripNameDialog(context);
        //
        //     if (tripName != null && tripName.isNotEmpty) {
        //       print("Places: $places");
        //       print("Itinerary: $itinerary");
        //
        //       // Convert List<Place> to List<Map<String, dynamic>> for the database
        //       List<Map<String, dynamic>> placesMap = places.map((place) {
        //         return {
        //           'name': place.name,
        //           'rating': place.rating,
        //         };
        //       }).toList();
        //
        //       // Parse itinerary into a map where the key is the day (Day 1, Day 2, etc.) and the value is a list of places
        //       Map<String, List<String>> itineraryMap = {};
        //
        //       for (String dayInfo in itinerary) {
        //         var parts = dayInfo.split(' - Suggested Activities: ');
        //         if (parts.length == 2) {
        //           String day = parts[0];  // Day 1, Day 2, etc.
        //           List<String> activities = parts[1]
        //               .split(', ')  // Split by commas to get each activity
        //               .map((activity) => activity.split(' (Rating: ')[0].trim())  // Remove rating part
        //               .toList();
        //
        //           itineraryMap[day] = activities;
        //         }
        //       }
        //
        //       // Convert itineraryMap into a List<Map<String, dynamic>> for the database
        //       List<Map<String, dynamic>> itineraryDbMap = [];
        //       itineraryMap.forEach((day, activities) {
        //         itineraryDbMap.add({
        //           'day': day,
        //           'activities': activities,  // This will store the list of activity names
        //         });
        //       });
        //
        //       // Save the trip with places and itinerary using DatabaseHelper
        //       final dbHelper = DatabaseHelper();
        //       await dbHelper.saveTrip(tripName, placesMap, itineraryDbMap);
        //
        //       // Optionally, show a confirmation message
        //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip saved successfully!')));
        //     } else {
        //       // Handle the case where the user cancels or leaves the name empty
        //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip name is required!')));
        //     }
        //   },
        //   child: Icon(Icons.save),
        //   backgroundColor: Colors.blue,
        // )
    );
  }

  Future<String?> _showTripNameDialog(BuildContext context) async {
    TextEditingController _controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Enter Trip Name',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          content: TextField(
            controller: _controller,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Enter Trip Name',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Center buttons
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_controller.text);  // Return the trip name
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();  // Cancel the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}
