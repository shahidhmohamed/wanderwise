import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/home_screen.dart';
import '../app/saved/saved_itinerary_screen.dart';
import '../util/LottieFiles.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserSignInStatus();
  }

  // void _checkUserSignInStatus() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   await Future.delayed(Duration(seconds: 3));
  //
  //   if (user != null) {
  //     print("User Found");
  //
  //     Get.off(() => HomeScreen(),
  //         transition: Transition.rightToLeft,
  //         curve: Curves.easeInCubic,
  //         duration: const Duration(milliseconds: 1000));
  //   } else {
  //     Get.off(() => LoginPage(),
  //         transition: Transition.rightToLeft,
  //         curve: Curves.easeInCubic,
  //         duration: const Duration(milliseconds: 1000));
  //   }
  // }

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No connectivity
    }
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false; // Unable to reach the internet
    }
  }

  void _checkUserSignInStatus() async {
    // Check for internet connectivity
    if (!await hasInternetConnection()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No internet connection. Redirecting to saved trips...',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        ),
      );

      Get.off(() => SavedItineraryScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 1000));
      return; // Exit the function after handling offline mode
    }

    // Check if the user is signed in
    User? user = FirebaseAuth.instance.currentUser;

    await Future.delayed(Duration(seconds: 3)); // Splash screen delay

    if (user != null) {
      // User is signed in
      print("User Found");
      Get.off(() => HomeScreen(),
          transition: Transition.rightToLeft,
          curve: Curves.easeInCubic,
          duration: const Duration(milliseconds: 1000));
    } else {
      // No user found
      Get.off(() => LoginPage(),
          transition: Transition.rightToLeft,
          curve: Curves.easeInCubic,
          duration: const Duration(milliseconds: 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 85.0),
              child: LottieFiles().winsplash(),
            ),
            Center(
              child: SizedBox(
                width: Get.width > 500 ? 300 : Get.width / 1,
                child: const Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage('assets/logos/splash_logo.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
