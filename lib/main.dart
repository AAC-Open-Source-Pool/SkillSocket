import 'package:barter_system/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart'; 

void main(){
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
