import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wanderwise/initial/splash_screen.dart';

import 'controllers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCwIBr0qZJBqz4f4VX59uS0P6CxzBXQr68",
        appId: "1:158649012456:web:ac75b750d2f0eca62db95d",
        messagingSenderId: "158649012456",
        projectId: "wanderwise-86418",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    themeController.loadSavedTheme();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode:
          themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
