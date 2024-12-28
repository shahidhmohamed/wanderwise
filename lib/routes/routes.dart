import 'package:get/get.dart';
import 'package:wanderwise/initial/splash_screen.dart';
import 'package:wanderwise/initial/login_page.dart';

class Routes {
  // Define your app's routes in a centralized manner
  static final List<GetPage> pages = [
    GetPage(name: '/', page: () => SplashScreen()), // Splash Screen
    GetPage(name: '/login', page: () => LoginPage()), // Login Page
  ];
}
