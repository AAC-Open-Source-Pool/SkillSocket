import 'package:barter_system/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barter System',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: const Color(0xFF56195B),
      ),
      home: const LoginScreen(),
    );
  }
}
