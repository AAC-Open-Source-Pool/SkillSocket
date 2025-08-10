import 'package:flutter/material.dart';
import 'package:barter_system/home.dart';
import 'package:barter_system/chats.dart';
import 'package:barter_system/skillpopup.dart';
import 'package:barter_system/community.dart';
import 'package:barter_system/studyroom.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyHomePage(title: 'App name'),
    const Chats(),
    const SkillMatchApp(),
    const Community(),
    const StudyRoom(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF56195B),
        selectedItemColor: const Color(0xFFECC9EE),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outlined), label: 'ADD'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded), label: 'Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'Study Room'),
        ],
      ),
    );
  }
}
