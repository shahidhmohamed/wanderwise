import '../models/place.dart';

class TripPlanner {
  double budget;
  int duration;
  double dailyBudget;
  List<String> itinerary;
  List<Place> places;

  TripPlanner(
      {required this.budget, required this.duration, required this.places})
      : dailyBudget = duration > 0 ? budget / duration : 0,
        itinerary = [];

  void generateItinerary() {
    itinerary.clear();
    int placesPerDay = (places.length ~/ duration).clamp(1, places.length);

    for (int day = 1; day <= duration; day++) {
      String dayPlaces = places
          .skip((day - 1) * placesPerDay)
          .take(placesPerDay)
          .map((place) => '${place.name} (Rating: ${place.rating})')
          .join(', ');

      if (dayPlaces.isEmpty) {
        dayPlaces = 'No places available for this day.';
      }

      itinerary.add(
          'Day $day: Spend up to \$${dailyBudget.toStringAsFixed(2)} - Suggested Activities: $dayPlaces');
    }
  }
}
