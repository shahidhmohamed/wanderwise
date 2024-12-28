import 'package:flutter/material.dart';

import '../../controllers/places_controller.dart';
import '../../controllers/trip_planner.dart';
import '../../models/place.dart';
import 'itinerary_screen.dart';


class TripInputScreen extends StatefulWidget {
  @override
  _TripInputScreenState createState() => _TripInputScreenState();
}

class _TripInputScreenState extends State<TripInputScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final PlacesController placesController = PlacesController(apiKey: 'AIzaSyB5zxGGP_ydXAdIptfpjGdmcEEs_i42_KU');

  void _planTrip() async {
    String destination = _destinationController.text; // E.g., "Sri Lanka"
    double budget = double.tryParse(_budgetController.text) ?? 0;
    int days = int.tryParse(_daysController.text) ?? 0;

    try {
      // Fetch places based on the user input
      List<Place> places = await placesController.fetchPlaces(destination);
      print('Fetched Places: $places');

      // Create a TripPlanner object
      TripPlanner tripPlanner = TripPlanner(budget: budget, duration: days, places: places);
      tripPlanner.generateItinerary();

      // Navigate to the itinerary screen with the generated itinerary
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItineraryScreen(places: places, itinerary: tripPlanner.itinerary),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plan Your Trip')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            TextField(
              controller: _budgetController,
              decoration: InputDecoration(labelText: 'Budget'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _daysController,
              decoration: InputDecoration(labelText: 'Days'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _planTrip,
              child: Text('Plan Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
