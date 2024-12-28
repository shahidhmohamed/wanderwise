import 'package:flutter/material.dart';

class PlanTrip extends StatefulWidget {
  const PlanTrip({super.key});

  @override
  State<PlanTrip> createState() => _PlanTripState();
}

class _PlanTripState extends State<PlanTrip> {
  // Controllers for each input
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  // List of icons for each box
  final List<IconData> _icons = [
    Icons.location_on, // Icon for Country
    Icons.attach_money, // Icon for Budget
    Icons.calendar_today, // Icon for Days
    Icons.check_circle, // Icon for Confirm/Submit
  ];

  @override
  void dispose() {
    // Dispose each controller when the widget is removed
    _countryController.dispose();
    _budgetController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Colors.black,
        //       Colors.white,
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     stops: [0.2, 0.4],
        //   ),
        // ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Two boxes per row
                mainAxisSpacing: 16, // Space between rows
                crossAxisSpacing: 16, // Space between columns
                children: [
                  _buildInputBox(
                      _countryController, _icons[0], 'Enter Country'),
                  _buildInputBox(_budgetController, _icons[1], 'Enter Budget'),
                  _buildInputBox(_daysController, _icons[2], 'Enter Days'),
                  _buildInputBox(_daysController, _icons[2], 'Enter Days'),


                  // IconButton(onPressed: (){}, icon: Icon(Icons.ice_skating))
                ],
              ),
            ),
            Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 200, // Fixed width for SizedBox
                      ),
                      Text(
                        "Plan Your Trip",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      _buildSubmitButton()
                    ],
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }

  // Method to build input boxes
  Widget _buildInputBox(
      TextEditingController controller, IconData icon, String hintText) {
    return SizedBox(
      width: 180, // Set a width for the boxes
      height: 180, // Set a height for the boxes
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Icon(icon,
                size: 40, color: Colors.white), // Use the icon from the list
            SizedBox(height: 30), // Space between icon and text field
            Expanded(
              child: TextField(
                controller: controller, // Assign the respective controller
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[900],
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the submit button
  Widget _buildSubmitButton() {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Handle the submission logic here
              print('Country: ${_countryController.text}');
              print('Budget: ${_budgetController.text}');
              print('Days: ${_daysController.text}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
