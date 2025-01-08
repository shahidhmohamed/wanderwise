import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wanderwise/app/explore/view_details.dart';
import 'dart:ui';
import '../../controllers/theme_controller.dart';
import '../../db_helper/db_helper.dart';
import '../../models/place.dart';
import '../../widgets/TimeLineTileUI.dart';
import '../../widgets/dotbar_widget_2.dart';
import 'package:get/get.dart';

class ItineraryScreen extends StatelessWidget {
  final List<Place> places;
  final List<String> itinerary;

  const ItineraryScreen(
      {super.key, required this.places, required this.itinerary});

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
            Navigator.pop(context);
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
              String? tripName = await _showTripNameDialog(context);

              if (itinerary != null && tripName != null) {
                print("Itinerary: $itinerary");

                String itineraryString = itinerary.join(', ');

                final dbHelper = DatabaseHelper();
                await dbHelper.saveTrip(tripName, itineraryString);

                print('Trip saved successfully');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Trip saved successfully!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Trip name is required!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                  ),
                );
              }
            },
            child: Icon(
              FontAwesomeIcons.download,
              color:
                  themeController.isDarkMode.value ? Colors.white : Colors.blue,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: itinerary.length,
        itemBuilder: (context, index) {
          final dayInfo = itinerary[index];
          final place = places[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewPlacePage(article: place, dayInfo: dayInfo),
                ),
              );
            },
            child: TimeLineTileUI(
              isFirst: index == 0,
              isLast: index == itinerary.length - 1,
              isPast: index < DateTime.now().day,
              eventChild: Stack(
                children: [
                  if (place.photos.isNotEmpty)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(),
                          child: Image.network(
                            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place.photos[0].photoReference}&key=AIzaSyB5zxGGP_ydXAdIptfpjGdmcEEs_i42_KU',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 70,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 6),
                        Center(
                          child: DotBar(rating: place.rating),
                        ),
                        SizedBox(height: 8),
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
    );
  }

  Future<String?> _showTripNameDialog(BuildContext context) async {
    TextEditingController _controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.7),
          title: Text(
            'Enter Trip Name',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
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
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_controller.text);
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
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
