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
  bool isExpanded = false;

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

  Widget _buildProfileCard(Map<String, String> profile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: MediaQuery.of(context).size.width * 0.9,
      height: isExpanded ? 500 : 380,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : const AssetImage('assets/avatar.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile["name"]!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(profile["profession"]!,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(thickness: 1.5),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Skills Offered:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(profile["skillsOffered"]!),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Skills Required:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(profile["skillsRequired"]!),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Ratings:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(profile["ratings"]!),
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          const Divider(thickness: 1),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Education:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              Text(profile["education"]!),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Location:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              Text(profile["location"]!),
                            ],
                          ),
                        ],
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => isExpanded = !isExpanded),
            icon: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),
        ],
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
                  height: isExpanded ? 500 : 380,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: SwipableStack(
                    controller: _controller,
                    detectableSwipeDirections: const {
                      SwipeDirection.left,
                      SwipeDirection.right
                    },
                    builder: (context, properties) {
                      final profile = profiles[properties.index % profiles.length];
                      return _buildProfileCard(profile);
                    },
                    onSwipeCompleted: (index, direction) {
                      if (direction == SwipeDirection.right) {
                        _saveForm();
                      }
                    },
                  ),
                ),
              ),

              Positioned(
                bottom: 45,
                left: (screenWidth / 2) - buttonSpacing - 28,
                child: FloatingActionButton(
                  heroTag: 'reject',
                  backgroundColor: Colors.redAccent,
                  onPressed: () => _controller.next(swipeDirection: SwipeDirection.left),
                  child: const Icon(Icons.close, size: 30, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 45,
                left: (screenWidth / 2) + buttonSpacing - 28,
                child: FloatingActionButton(
                  heroTag: 'accept',
                  backgroundColor: Colors.green,
                  onPressed: () => _controller.next(swipeDirection: SwipeDirection.right),
                  child: const Icon(Icons.check, size: 28, color: Colors.white),
                ),
              ),

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
