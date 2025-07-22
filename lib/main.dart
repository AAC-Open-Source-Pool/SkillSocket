import 'package:barter_system/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBv5na4roNQdiwWzWeYsxcXe3UofbDLsgE",
        authDomain: "aacr02-24235.firebaseapp.com",
        projectId: "aacr02-24235",
        storageBucket: "aacr02-24235.firebasestorage.app",
        messagingSenderId: "69467650385",
        appId: "1:69467650385:web:ad211625527c9619b13b70",
        measurementId: "G-49LXKD4FSE"
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Page',
      home: LoginScreen(),
    );
  }
}
