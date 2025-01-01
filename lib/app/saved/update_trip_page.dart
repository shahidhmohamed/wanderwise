import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/theme_controller.dart';
import '../../db_helper/db_helper.dart';

class UpdateTripPage extends StatefulWidget {
  final int dayID;
  final int id;
  final String budget;
  final List<String> activities;
  final String tripName;

  const UpdateTripPage(
      {super.key,
        required this.dayID,
      required this.id,
      required this.budget,
      required this.activities,
      required this.tripName});

  @override
  State<UpdateTripPage> createState() => _UpdateTripPageState();
}

class _UpdateTripPageState extends State<UpdateTripPage> {
  late TextEditingController _budgetController;
  late List<TextEditingController> _activityControllers;

  Future<void> _saveChanges() async {
    if (_budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget cannot be empty')),
      );
      return;
    }

    // Collect updated budget and activities
    String updatedBudget = _budgetController.text;
    List<String> updatedActivities =
        _activityControllers.map((controller) => controller.text).toList();

    // Construct the updated itinerary string
    String updatedItinerary =
        'Day ${widget.dayID}: Spend up to $updatedBudget - Suggested Activities: ${updatedActivities.join(', ')}';

    // Prepare updated values for the database
    final updatedValues = {
      'trip_name': widget.tripName,
      'itinerary': updatedItinerary,
    };

    print("Updating trip with ID: ${widget.id}");
    print("Updated values: $updatedValues");

    // Update the trip in the database
    final dbHelper = DatabaseHelper();
    int result = await dbHelper.updateTrip(widget.id, updatedValues);
    print("Update result: $result");

    if (result > 0) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update trip')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _budgetController = TextEditingController(text: widget.budget ?? '');
    _activityControllers = widget.activities
        .map((activity) => TextEditingController(text: activity ?? ''))
        .toList();
  }

  @override
  void dispose() {
    // Dispose controllers
    _budgetController.dispose();
    for (var controller in _activityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Trip'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.tripName.toUpperCase(), // Display the ID
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: 'Budget',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            Text(
              'Activities:', // Display the title for activities
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _activityControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _activityControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Activity ${index + 1}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
