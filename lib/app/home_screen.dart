import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:wanderwise/app/explore/explore_page.dart';
import 'package:wanderwise/app/explore/itinerary_screen.dart';
import 'package:wanderwise/app/explore/plan_trip.dart';
import 'package:wanderwise/app/explore/trip_input_screen.dart';
import 'package:wanderwise/app/favorite/favorite_screen.dart';
import 'package:wanderwise/app/home/home_page.dart';
import 'package:wanderwise/app/profile/profile_page.dart';
import 'package:wanderwise/initial/login_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    FavoriteScreen(),
    TripInputScreen(),
    PlanTrip()
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
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.white,
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: IconlyBold.heart,
              unselectedIcon: IconlyLight.heart,
              selectedColor: Colors.red,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: IconlyBold.plus,
              unselectedIcon: IconlyLight.plus,
              selectedColor: Colors.white,
            ),

            /// Search
            CrystalNavigationBarItem(
              icon: IconlyBold.search,
              unselectedIcon: IconlyLight.search,
              selectedColor: Colors.white,
            ),

            /// Profile (Example of a Profile page)
            CrystalNavigationBarItem(
              icon: IconlyBold.user_2,
              unselectedIcon: IconlyLight.user,
              selectedColor: Colors.white,
            ),
          ],
        ),
      ),
      // Sign-out button (can be added in the top or profile tab for logout)
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _signOut,
      //   child: Icon(Icons.logout),
      //   backgroundColor: Colors.red,
      // ),
    );
  }
}
