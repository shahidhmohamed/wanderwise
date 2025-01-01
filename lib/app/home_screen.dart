import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:wanderwise/app/explore/plan_trip.dart';
import 'package:wanderwise/app/favorite/favorite_screen.dart';
import 'package:wanderwise/app/home/home_page.dart';
import 'package:wanderwise/app/saved/saved_itinerary_screen.dart';
import 'package:wanderwise/app/settings/settings_page.dart';
import 'package:wanderwise/initial/login_page.dart';
import '../controllers/theme_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    PlanTrip(),
    HomePage(),
    FavoritesScreen(),
    SavedItineraryScreen(),
    SettingsPage()
    // TripInputScreen(),

  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Sign-out method
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => LoginPage());  // Navigate to LoginPage after sign-out
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? Colors.black : Colors.white,
      extendBody: true,
      body: _screens[_selectedIndex],  // Display the selected screen here

      // Bottom Navigation Bar (CrystalNavigationBar or BottomNavigationBar)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.5),
          onTap: _onItemTapped,
          items: [
            /// Home
            CrystalNavigationBarItem(
            icon: FontAwesomeIcons.plane,
              unselectedIcon: FontAwesomeIcons.planeUp,
              selectedColor: Colors.white,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: FontAwesomeIcons.searchengin,
              unselectedIcon: FontAwesomeIcons.searchLocation,
              selectedColor: Colors.white,
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: IconlyBold.heart,
              unselectedIcon: IconlyLight.heart,
              selectedColor: Colors.red,
            ),

            /// Saved
            CrystalNavigationBarItem(
              icon: FontAwesomeIcons.solidSave,
              unselectedIcon: FontAwesomeIcons.save,
              selectedColor: Colors.red,
            ),

            /// Search
            CrystalNavigationBarItem(
              icon: IconlyBold.setting,
              unselectedIcon: IconlyLight.setting,
              selectedColor: Colors.white,
            ),

          ],
        ),
      ),
      // Sign-out button (can be added in the top or settings tab for logout)
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _signOut,
      //   child: Icon(Icons.logout),
      //   backgroundColor: Colors.red,
      // ),
    );
  }
}
