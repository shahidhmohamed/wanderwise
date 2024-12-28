import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanderwise/initial/login_page.dart';
import 'package:wanderwise/initial/splash_screen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyCwIBr0qZJBqz4f4VX59uS0P6CxzBXQr68", appId: "1:158649012456:web:ac75b750d2f0eca62db95d", messagingSenderId: "158649012456", projectId: "wanderwise-86418"));
  }
  else{
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
