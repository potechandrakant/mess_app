import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/views/common/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "API_KEY",
      appId: "APP_ID",
      messagingSenderId: "405579145777",
      projectId: "PROJECT_ID",
    ),
  );
  runApp(const MessApp());
}

class MessApp extends StatelessWidget {
  const MessApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
