import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wanderwise/app/saved/update_trip_page.dart';

import '../../controllers/theme_controller.dart';

class SavedItineraryDetailsScreen extends StatefulWidget {
  final String itinerary;
  final int tripID;
  final String tripName;

  SavedItineraryDetailsScreen({required this.itinerary, required this.tripID, required this.tripName});

  @override
  _SavedItineraryDetailsScreenState createState() => _SavedItineraryDetailsScreenState();
}

class _SavedItineraryDetailsScreenState extends State<SavedItineraryDetailsScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    List<String> days = widget.itinerary.split('Day');
    days.removeAt(0);

    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: days.length,
          itemBuilder: (context, index) {
            final dayContent = days[index].trim();
            List<String> parts = dayContent.split('Suggested Activities:');
            String budgetLine = parts[0].trim();
            String activitiesContent = parts.length > 1 ? parts[1].trim() : '';

            RegExp budgetRegExp = RegExp(r'Spend up to \$(\d+(\.\d{1,2})?)');
            String? budget = budgetRegExp.firstMatch(budgetLine)?.group(0);

            List<String> activities = activitiesContent.split(', ');

            return GestureDetector(
              onTap: () async {
                final int id = index;
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateTripPage(
                      dayID: id,
                      tripName: widget.tripName,
                      id: widget.tripID,
                      budget: budget ?? 'No budget info available',
                      activities: activities,
                    ),
                  ),
                );
                if (updated == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Trip Updated',
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
                  Navigator.pop(context, true);
                  setState(() {});
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DAY ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(FontAwesomeIcons.edit, color: Colors.white),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        budget ?? 'No budget info available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent,
                        ),
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: activities.map((activity) {
                          List<String> activityParts = activity.split('(Rating: ');
                          String activityName = activityParts[0].trim();
                          String rating = activityParts.length > 1
                              ? activityParts[1].replaceAll(')', '').trim()
                              : 'N/A';

                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(FontAwesomeIcons.plane, size: 16, color: Colors.yellow),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '$activityName (Rating: $rating)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
