// lib/controllers/places_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wanderwise/models/place.dart';

class PlacesController {
  final String apiKey;

  PlacesController({required this.apiKey});

  // Fetching nearby places from the Google Places API
  Future<List<Place>> fetchNearbyPlaces(double latitude, double longitude , String type) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1000&type=$type&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Place> places = [];
      for (var result in data['results']) {
        places.add(Place.fromJson(result));
      }
      return places;
    } else {
      throw Exception('Failed to load places');
    }
  }


  Future<List<LatLng>> fetchDirections(double startLat, double startLng, double endLat, double endLng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    print("Response Body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if the 'routes' and 'legs' are available
      if (data['routes'] != null && data['routes'].isNotEmpty && data['routes'][0]['legs'] != null && data['routes'][0]['legs'].isNotEmpty) {
        List<LatLng> points = [];

        // Iterating through the steps to collect coordinates
        for (var step in data['routes'][0]['legs'][0]['steps']) {
          final startLocation = step['start_location'];
          points.add(LatLng(startLocation['lat'], startLocation['lng']));
        }

        // Add the destination point (end location)
        points.add(LatLng(endLat, endLng));

        return points;
      } else {
        // Log an error and return an empty list if no routes or legs are found
        print('No routes or legs found in the response.');
        return [];
      }
    } else {
      // Log error if the request fails
      print('Failed to load directions, Status code: ${response.statusCode}');
      throw Exception('Failed to load directions');
    }
  }

  Future<List<Place>> fetchPlaces(String country) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=top+tourist+attractions+in+$country&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }

}
