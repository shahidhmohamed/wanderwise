import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // RxBool isDarkMode = false.obs;  // Observable variable to track theme
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   loadTheme();
  // }
  //
  // // Load the theme preference from SharedPreferences
  // Future<void> loadTheme() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   isDarkMode.value = prefs.getBool('isDarkMode') ?? false;  // Default to light mode
  //   updateThemeMode();  // Apply the theme after loading
  // }
  //
  // // Toggle the theme and save the new preference
  // void toggleTheme(bool value) async {
  //   isDarkMode.value = value;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isDarkMode', value);  // Save theme preference
  //   updateThemeMode();  // Apply the theme immediately
  // }
  //
  // // Update the app's theme mode dynamically
  // void updateThemeMode() {
  //   if (isDarkMode.value) {
  //     Get.changeThemeMode(ThemeMode.dark);  // Apply dark theme
  //   } else {
  //     Get.changeThemeMode(ThemeMode.light);  // Apply light theme
  //   }
  // }
  // Reactive variable to track whether the app is in dark mode
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedTheme();  // Load the saved theme preference when the controller is initialized
  }

  // Load the saved theme preference from GetStorage
  void loadSavedTheme() {
    bool? savedTheme = GetStorage().read('IS_DARK');
    if (savedTheme != null) {
      isDarkMode.value = savedTheme;  // Set the reactive value based on the saved theme
      // Apply the theme globally using Get.changeTheme()
      Get.changeTheme(savedTheme ? ThemeData.dark() : ThemeData.light());
    }
  }

  // Method to toggle the theme between dark and light mode
  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;  // Update the theme state

    // Apply the theme globally
    if (isDark) {
      Get.changeTheme(ThemeData.dark());  // Apply dark theme
    } else {
      Get.changeTheme(ThemeData.light());  // Apply light theme
    }

    // Save the theme preference in GetStorage for future app sessions
    GetStorage().write('IS_DARK', isDark);
  }
}
