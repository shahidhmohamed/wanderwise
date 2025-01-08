import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/places_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/trip_planner.dart';
import '../../models/place.dart';
import 'itinerary_screen.dart';

class PlanTrip extends StatefulWidget {
  const PlanTrip({super.key});

  @override
  State<PlanTrip> createState() => _PlanTripState();
}

class _PlanTripState extends State<PlanTrip> {
  bool _isLoading = false;
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final PlacesController placesController =
      PlacesController(apiKey: 'AIzaSyB5zxGGP_ydXAdIptfpjGdmcEEs_i42_KU');

  final List<IconData> _icons = [
    FontAwesomeIcons.locationDot,
    FontAwesomeIcons.dollarSign,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.peopleGroup,
  ];

  @override
  void dispose() {
    _destinationController.dispose();
    _budgetController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
          themeController.isDarkMode.value ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeController.isDarkMode.value ? Colors.black : Colors.white,
        title: Center(
          child: Text(
            'Plan Your Trip',
            style: TextStyle(
              color: themeController.isDarkMode.value
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 350,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildInputBox(
                        _destinationController, _icons[0], 'Enter Country'),
                    _buildInputBox(
                        _budgetController, _icons[1], 'Enter Budget'),
                    _buildInputBox(_daysController, _icons[2], 'Enter Days'),
                    _buildInputBox(_peopleController, _icons[3], 'People'),
                  ],
                ),
              ),
              Center(
                child: Text(
                  "✈️ Ready to Explore? 🌍\nPlan Your Dream Trip Today!",
                  style: TextStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 46),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox(
      TextEditingController controller, IconData icon, String hintText) {
    final ThemeController themeController = Get.find();
    return SizedBox(
      width: 160,
      height: 160,
      child: Container(
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value
              ? Colors.grey[800]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                themeController.isDarkMode.value ? Colors.white : Colors.black,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(
                      icon,
                      size: 40,
                      color: themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey
                        : Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final ThemeController themeController = Get.find();
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              print('Country: ${_destinationController.text}');
              print('Budget: ${_budgetController.text}');
              print('Days: ${_daysController.text}');
              print('Days: ${_peopleController.text}');
              _planTrip();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeController.isDarkMode.value
                  ? Colors.grey[700]
                  : Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    "Let's Go! 🚀",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _planTrip() async {
    setState(() {
      _isLoading = true;
    });
    String destination = _destinationController.text;
    double budget = double.tryParse(_budgetController.text) ?? 0;
    int days = int.tryParse(_daysController.text) ?? 0;

    try {
      List<Place> places = await placesController.fetchPlaces(destination);
      print('Fetched Places: $places');

      setState(() {
        _isLoading = false;
      });

      TripPlanner tripPlanner =
          TripPlanner(budget: budget, duration: days, places: places);
      tripPlanner.generateItinerary();

      Get.to(
          () =>
              ItineraryScreen(places: places, itinerary: tripPlanner.itinerary),
          transition: Transition.rightToLeft,
          curve: Curves.easeInCirc,
          duration: const Duration(milliseconds: 1000));
    } catch (e) {
      print('Error: $e');
    }
  }
}
