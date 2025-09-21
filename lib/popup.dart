import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  final String requiredSkill;
  final String offeredSkill;

  const ProfileEditScreen({
    super.key,
    required this.requiredSkill,
    required this.offeredSkill,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final SwipableStackController _controller = SwipableStackController();
  bool isExpanded = true;
  Map<int, bool> expandedProfiles = {}; // track which profiles are expanded

  final List<Map<String, dynamic>> profiles = [
    {
      "name": "Alara",
      "skillsOffered": "Flutter, Dart",
      "skillsRequired": "Firebase, Backend",
      "ratingsValue": 4.5,
      "education": "B.Tech",
      "location": "India",
      "profession": "Student",
      "reviews": [
        {
          "reviewer": "Mahmood Mustakeem",
          "rating": 5.0,
          "title": "Worth buying very good",
          "date": "15 July 2025",
          "comment":
              "Very good student, got a good deal in hackathon. Excellent collaboration and coding. Worth teaming up."
        },
        {
          "reviewer": "Gayathri",
          "rating": 4.0,
          "title": "Good project partner",
          "date": "12 July 2025",
          "comment":
              "Good project partner but sometimes slow in backend tasks. Otherwise everything going good. Helpful and supportive."
        }
      ]
    },
    {
      "name": "Ethan",
      "skillsOffered": "Java, Spring",
      "skillsRequired": "UI/UX, Flutter",
      "ratingsValue": 5.0,
      "education": "M.Tech",
      "location": "USA",
      "profession": "Developer",
      "reviews": [
        {
          "reviewer": "Abhishek",
          "rating": 5.0,
          "title": "Screen clarity",
          "date": "17 Aug 2025",
          "comment": "Amazing developer, delivers clean and scalable code."
        },
        {
          "reviewer": "Sophia",
          "rating": 5.0,
          "title": "Perfect teammate",
          "date": "10 Aug 2025",
          "comment": "Super reliable, proactive and skilled in Java backend."
        }
      ]
    },
    {
      "name": "Sophia",
      "skillsOffered": "Python, AI",
      "skillsRequired": "Cloud, Backend",
      "ratingsValue": 4.0,
      "education": "B.Sc",
      "location": "UK",
      "profession": "Data Scientist",
      "reviews": [
        {
          "reviewer": "Ethan",
          "rating": 4.0,
          "title": "AI knowledge is strong",
          "date": "5 July 2025",
          "comment": "Very good at AI but could improve cloud integration."
        },
        {
          "reviewer": "Alara",
          "rating": 4.0,
          "title": "Helpful in ML",
          "date": "28 June 2025",
          "comment":
              "Explains ML concepts well, collaborative in research work."
        }
      ]
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

  Widget _buildProfileCard(Map<String, dynamic> profile, int index) {
    return SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFFB6E1F0),
              ),
              const SizedBox(height: 16),

              // Name & Profession
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

              // ⭐ Overall Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (starIndex) {
                  double rating = (profile["ratingsValue"] ?? 0).toDouble();
                  if (starIndex < rating.floor()) {
                    return const Icon(Icons.star, color: Colors.teal, size: 28);
                  } else if (starIndex < rating && rating % 1 != 0) {
                    return const Icon(Icons.star_half,
                        color: Colors.teal, size: 28);
                  } else {
                    return const Icon(Icons.star_border,
                        color: Colors.teal, size: 28);
                  }
                }),
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
                    color: Color(0xFF123b53),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  Chip(label: Text(widget.offeredSkill)),
                ],
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
                    color: Color(0xFF123b53),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  Chip(label: Text(widget.requiredSkill)),
                ],
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
              const SizedBox(height: 20),

              // 🔽 Reviews header row
              Row(
                children: [
                  const Text(
                    "Reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123b53),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Rating number
                  Text(
                    (profile["ratingsValue"] ?? 0).toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Stars (with half star logic)
                  Row(
                    children: List.generate(5, (starIndex) {
                      double rating = (profile["ratingsValue"] ?? 0).toDouble();
                      if (starIndex < rating.floor()) {
                        return const Icon(Icons.star,
                            color: Colors.amber, size: 20);
                      } else if (starIndex < rating && rating % 1 != 0) {
                        return const Icon(Icons.star_half,
                            color: Colors.amber, size: 20);
                      } else {
                        return const Icon(Icons.star_border,
                            color: Colors.amber, size: 20);
                      }
                    }),
                  ),

                  const Spacer(),

                  // Expand/Collapse button
                  IconButton(
                    icon: Icon(
                      expandedProfiles[index] == true
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        expandedProfiles[index] =
                            !(expandedProfiles[index] ?? false);
                      });
                    },
                  ),
                ],
              ),

              // ✅ Show reviews if expanded
              if (expandedProfiles[index] == true) ...[
                const SizedBox(height: 12),
                Column(
                  children: (profile["reviews"] as List<dynamic>).map((review) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Reviewer name + rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review["reviewer"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  double rating =
                                      (review["rating"] ?? 0).toDouble();
                                  if (starIndex < rating.floor()) {
                                    return const Icon(Icons.star,
                                        color: Colors.amber, size: 18);
                                  } else if (starIndex < rating &&
                                      rating % 1 != 0) {
                                    return const Icon(Icons.star_half,
                                        color: Colors.amber, size: 18);
                                  } else {
                                    return const Icon(Icons.star_border,
                                        color: Colors.amber, size: 18);
                                  }
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            review["title"],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            review["date"],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            review["comment"],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
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
            colors: [Color(0xFFB6E1F0), Color(0xFF66B7D2), Color(0xFF123b53)],
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
                      return _buildProfileCard(profile, properties.index);
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
                  child: const Icon(Icons.close, size: 30, color: Colors.white),
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
                  child: const Icon(Icons.check, size: 28, color: Colors.white),
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
