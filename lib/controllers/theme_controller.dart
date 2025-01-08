import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedTheme();
  }

  void loadSavedTheme() {
    bool? savedTheme = GetStorage().read('IS_DARK');
    if (savedTheme != null) {
      isDarkMode.value = savedTheme;

      Get.changeTheme(savedTheme ? ThemeData.dark() : ThemeData.light());
    }
  }

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;

    if (isDark) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }

    GetStorage().write('IS_DARK', isDark);
  }
}
