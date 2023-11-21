import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizzapp/screens/home_screen.dart';
import 'package:quizzapp/screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCTQBQc1qSM74ya6lSGVJiTBdUp58a3A9Q",
      appId: "1:803189623466:android:6b3477f2043d2dc7a85ed3",
      messagingSenderId: "803189623466",
      projectId: "learngerman-dcaf3",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}

