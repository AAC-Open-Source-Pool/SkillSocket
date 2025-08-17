import 'package:flutter/material.dart';
import 'package:barter_system/notification.dart';
import 'package:barter_system/popup.dart';
import 'package:barter_system/profile.dart';

class SkillMatchApp extends StatelessWidget {
  const SkillMatchApp({super.key});
  @override
  Widget build(BuildContext context) {
    final requireController = TextEditingController();
    final offerController = TextEditingController();
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
          title: const Text(
            'APP NAME',
            style: TextStyle(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: const Color(0xFF56195B),
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notifications()));
                },
                icon: const Icon(Icons.notifications)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                icon: const Icon(Icons.person_rounded)),
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
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 30),
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
                  const SizedBox(height: 25),
                  Row(
                    children: const [
                      Text(
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
                      fillColor: Color(0xFFE8CFF7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Text(
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
                      fillColor: Color(0xFFE8CFF7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D1A6A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileEditScreen()));
                      },
                      child: const Text("NEXT",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
