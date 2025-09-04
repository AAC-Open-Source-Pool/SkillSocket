import 'package:flutter/material.dart';
import 'package:barter_system/notification.dart';
import 'package:barter_system/popup.dart';
import 'package:barter_system/profile.dart';

class SkillMatchApp extends StatefulWidget {
  const SkillMatchApp({super.key});

  @override
  State<SkillMatchApp> createState() => _SkillMatchAppState();
}

class _SkillMatchAppState extends State<SkillMatchApp> {
  final _formKey = GlobalKey<FormState>();
  final requireController = TextEditingController();
  final offerController = TextEditingController();

  // Regex allows alphabets, spaces, +, -, .
  final RegExp skillRegex = RegExp(r"^[a-zA-Z\s\+\-\.]{2,}$");

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
          title: const Text(
            'APP NAME',
            style: TextStyle(
              fontSize: 32,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF56195B),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
              icon: const Icon(Icons.notifications),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Profile()));
              },
              icon: const Icon(Icons.person_rounded),
            ),
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Enter to Match!',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 25),

                    // Skill Required
                    Row(
                      children: const [
                        Text(
                          'Skill Required',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: requireController,
                      decoration: const InputDecoration(
                        hintText: 'Skill you require',
                        filled: true,
                        fillColor: Color(0xFFE8CFF7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a required skill";
                        } else if (!skillRegex.hasMatch(value.trim())) {
                          return "Enter a valid skill (letters, +, -, . allowed)";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Skill Offered
                    Row(
                      children: const [
                        Text(
                          'Skill Offered',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: offerController,
                      decoration: const InputDecoration(
                        hintText: 'Skill you offer',
                        filled: true,
                        fillColor: Color(0xFFE8CFF7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a skill you offer";
                        } else if (!skillRegex.hasMatch(value.trim())) {
                          return "Enter a valid skill (letters, +, -, . allowed)";
                        }
                        return null;
                      },
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
                          if (_formKey.currentState!.validate()) {
                            // ✅ Only navigate if valid
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEditScreen(),
                              ),
                            );
                          }
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
      ),
    );
  }
}
