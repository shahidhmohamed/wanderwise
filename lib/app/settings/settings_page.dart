import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wanderwise/app/settings/profile/update_profile.dart';
import 'package:wanderwise/initial/login_page.dart';
import '../../controllers/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Get the ThemeController instance using GetX
    final ThemeController themeController = Get.find();

    return Scaffold(
      // Use Obx to reactively rebuild the backgroundColor based on the current theme
      body: Obx(() {
        return Scaffold(
          backgroundColor: themeController.isDarkMode.value ? Colors.black : Colors.white, // Set background color dynamically
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between items
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.user,
                          color: themeController.isDarkMode.value ? Colors.black : Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          // Implement save functionality if needed
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value ? Colors.grey[800] : Colors.grey[100],  // Set container background based on theme
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(FontAwesomeIcons.user, color: themeController.isDarkMode.value ? Colors.white : Colors.blue),
                        title: Text(
                          'Profile',
                          style: TextStyle(color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: themeController.isDarkMode.value ? Colors.white : Colors.blue),
                        onTap: () {
                          Get.to(() => UpdateUserProfile());
                        },
                      ),
                      Divider(color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.language, color: themeController.isDarkMode.value ? Colors.white : Colors.blue),
                        title: Text(
                          'Language',
                          style: TextStyle(color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: themeController.isDarkMode.value ? Colors.white : Colors.blue),
                        onTap: () {
                          // Add logic for language change if needed
                        },
                      ),
                      Divider(color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                      ListTile(
                        leading: Icon(
                          Icons.dark_mode,
                          color: themeController.isDarkMode.value ? Colors.white : Colors.blue,
                        ),
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(color:themeController.isDarkMode.value ? Colors.white : Colors.black),
                        ),
                        trailing: Obx(() {
                          return Switch(
                            value: themeController.isDarkMode.value,  // Reactively check the theme status
                            onChanged: (bool value) {
                              themeController.toggleTheme(value);  // Update the theme on toggle
                            },
                            activeColor: Colors.blue,  // Active color for the Switch
                          );
                        }),
                        onTap: () {
                          // Optional: You can add custom behavior when tapping on the tile if needed
                        },
                      ),
                      Divider(color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.signOut, color: themeController.isDarkMode.value ? Colors.white : Colors.blue),
                        title: Text(
                          'Logout',
                          style: TextStyle(color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: themeController.isDarkMode.value ? Colors.white : Colors.blue),
                        onTap: () {
                          _signOut();
                          Get.off(()=> LoginPage());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
