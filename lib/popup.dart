import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final SwipableStackController _controller = SwipableStackController();
  bool isExpanded = true;

  final List<Map<String, String>> profiles = [
    {
      "name": "Alara",
      "skillsOffered": "Flutter, Dart",
      "skillsRequired": "Firebase, Backend",
      "ratings": "⭐⭐⭐⭐☆",
      "education": "B.Tech",
      "location": "India",
      "profession": "Student"
    },
    {
      "name": "Ethan",
      "skillsOffered": "Java, Spring",
      "skillsRequired": "UI/UX, Flutter",
      "ratings": "⭐⭐⭐⭐⭐",
      "education": "M.Tech",
      "location": "USA",
      "profession": "Developer"
    },
    {
      "name": "Sophia",
      "skillsOffered": "Python, AI",
      "skillsRequired": "Cloud, Backend",
      "ratings": "⭐⭐⭐☆☆",
      "education": "B.Sc",
      "location": "UK",
      "profession": "Data Scientist"
    }
  ];

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _saveForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!")),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    return SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // slight round edges
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFFE1BEE7),
              ),
              const SizedBox(height: 16),
              Text(
                profile["name"] ?? "Unknown",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profile["profession"] ?? "",
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // ⭐ Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => const Icon(Icons.star, color: Colors.teal, size: 28),
                ),
              ),
              const SizedBox(height: 24),

              // 🟣 Skills Required
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Skills Required",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: (profile["skillsRequired"] as String)
                    .split(",")
                    .map((skill) => Chip(label: Text(skill.trim())))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // 🟣 Skills Offered
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Skills Offered",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: (profile["skillsOffered"] as String)
                    .split(",")
                    .map((skill) => Chip(label: Text(skill.trim())))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // 🌍 Location
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(profile["location"] ?? ""),
                ],
              ),
              const SizedBox(height: 12),

              // 🎓 Education
              Row(
                children: [
                  const Icon(Icons.language, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(profile["education"] ?? ""),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const buttonSpacing = 70;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEFEAEA),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD6A4A4), Color(0xFF5C1A82)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Swipeable stack of cards
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8, // bigger
                  width: MediaQuery.of(context).size.width * 0.95, // wider
                  child: SwipableStack(
                    controller: _controller,
                    detectableSwipeDirections: const {
                      SwipeDirection.left,
                      SwipeDirection.right
                    },
                    builder: (context, properties) {
                      final profile =
                          profiles[properties.index % profiles.length];
                      return _buildProfileCard(profile);
                    },
                    onSwipeCompleted: (index, direction) {
                      final profile = profiles[index % profiles.length];
                      if (direction == SwipeDirection.right) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "${profile["name"]} marked as Interested")),
                        );
                      } else if (direction == SwipeDirection.left) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "${profile["name"]} marked as Rejected")),
                        );
                      }
                    },
                  ),
                ),
              ),

              // Reject button
              Positioned(
                bottom: 5,
                left: (screenWidth / 2) - buttonSpacing - 28,
                child: FloatingActionButton(
                  heroTag: 'reject',
                  backgroundColor: Colors.redAccent,
                  onPressed: () =>
                      _controller.next(swipeDirection: SwipeDirection.left),
                  child: const Icon(Icons.close,
                      size: 30, color: Colors.white),
                ),
              ),

              // Accept button
              Positioned(
                bottom: 5,
                left: (screenWidth / 2) + buttonSpacing - 28,
                child: FloatingActionButton(
                  heroTag: 'accept',
                  backgroundColor: Colors.green,
                  onPressed: () =>
                      _controller.next(swipeDirection: SwipeDirection.right),
                  child:
                      const Icon(Icons.check, size: 28, color: Colors.white),
                ),
              ),

              // Back button
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
