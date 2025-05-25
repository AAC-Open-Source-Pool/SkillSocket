import 'package:barter_system/communities.dart';
import 'package:barter_system/history.dart';
import 'package:barter_system/login.dart';
import 'package:barter_system/profile.dart';
import 'package:barter_system/add.dart';
import 'package:barter_system/chats.dart';
import 'package:barter_system/reviews.dart';
import 'package:barter_system/studyroom.dart';
import 'package:barter_system/community.dart';
import 'package:barter_system/notification.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
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

