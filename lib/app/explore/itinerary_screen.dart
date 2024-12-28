import 'package:flutter/material.dart';
import 'package:wanderwise/models/place.dart';
class ItineraryScreen extends StatelessWidget {
  final List<Place> places;
  final List<String> itinerary;

  ItineraryScreen({required this.places, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Itinerary')),
      body: ListView.builder(
        itemCount: itinerary.length,
        itemBuilder: (context, index) {
          final dayInfo = itinerary[index];
          final place = places[index]; // Adjust if you want to show more than one place per day
          return Card(
            child: ListTile(
              leading: place.photos.isNotEmpty
                  ? Image.network('https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place.photos[0].photoReference}&key=AIzaSyB5zxGGP_ydXAdIptfpjGdmcEEs_i42_KU')
                  : null,
              title: Text(dayInfo),
              subtitle: Text('Place: ${place.name}, Rating: ${place.rating}'),
            ),
          );
        },
      ),
    );
  }
}
