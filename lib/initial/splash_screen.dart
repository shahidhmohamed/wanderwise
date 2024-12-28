import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/home_screen.dart';
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

  void _checkUserSignInStatus() async {
    // Check if the user is signed in
    User? user = FirebaseAuth.instance.currentUser;

    // Wait for the splash animation to finish, then navigate
    await Future.delayed(Duration(seconds: 3));

    // Navigate based on user authentication status
    if (user != null) {
      print("User Found");
      // If the user is already signed in, go to the HomePage
      Get.off(() => HomeScreen(), transition: Transition.rightToLeft, curve: Curves.easeInCubic, duration: const Duration(milliseconds: 1000));
    } else {
      // If the user is not signed in, go to the SignInPage
      Get.off(() => LoginPage(), transition: Transition.rightToLeft, curve: Curves.easeInCubic, duration: const Duration(milliseconds: 1000));
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
