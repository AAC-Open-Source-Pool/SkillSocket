import 'package:barter_system/notification.dart';
import 'package:barter_system/popup.dart';
import 'package:barter_system/profile.dart';
import 'package:flutter/material.dart';
import 'package:barter_system/studyroom.dart';
import 'package:barter_system/community.dart';
import 'package:barter_system/chats.dart';
import 'package:barter_system/home.dart';

class SkillMatchApp extends StatelessWidget {
  const SkillMatchApp({super.key});
  @override
  Widget build(BuildContext context) {
    return HomeScreen(); 
  }
}


class HomeScreen extends StatelessWidget {
  final TextEditingController requireController = TextEditingController();
  final TextEditingController offerController = TextEditingController();
  final int _selectedIndex = 2;
 final List<Widget> _pages = [
    MyHomePage(
      title: 'App name',
    ),
    Chats(),
    SkillMatchApp(),
    Community(),
    StudyRoom(),
  ];

  void _onItemTapped(BuildContext context,int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFD6A4A4), Color(0xFF5C1A82)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
       appBar: AppBar(
          centerTitle: true,
          title: Text(
            'APP NAME',
            style: TextStyle(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: Color(0xFF56195B),
          
          iconTheme:
              IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notifications()));
                },
                icon: Icon(Icons.notifications)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                icon: Icon(Icons.person_rounded)),
          ],
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD6A4A4), Color(0xFF5C1A82)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                        'Enter to Match!',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                SizedBox(height: 25,),
                Row(
                  children: [
                    const Text(
                            'Skill Required',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                  ],
                ),
                TextField(
                  controller: requireController,
                  decoration: InputDecoration(
                    hintText: 'Skill you require',
                    filled: true,
                    fillColor:const Color(0xFFE8CFF7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                            'Skill Offered',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                  ],
                ),
                TextField(
                  controller: offerController,
                  decoration: InputDecoration(
                    hintText: 'Skill you offer',
                    filled: true,
                    fillColor: const Color(0xFFE8CFF7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5D1A6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileEditScreen()));
                    },
                    child: Text("NEXT",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),)
        ),
        bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
      color: Color(0xFF56195B),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
        ),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final List<IconData> icons = [
          Icons.home,
          Icons.chat_bubble_rounded,
          Icons.add_circle_outlined,
          Icons.groups_rounded,
          Icons.menu_book_rounded,
        ];
        final List<String> labels = ['Home', 'Chats', 'ADD', 'Community', 'Study Room'];
        final isSelected = index == _selectedIndex;
      
        return GestureDetector(
          onTap: () => _onItemTapped(context,index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 12 : 0, vertical: 8),
            decoration: isSelected
                ? BoxDecoration(
                    color: Color(0xFFECC99EE),
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Row(
              children: [
                Icon(icons[index], color: isSelected ? Colors.white : Colors.white70),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(labels[index], style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ),
        );
      }),
        ),
      ),
      ),
    );
  }
}
