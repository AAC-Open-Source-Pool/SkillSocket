import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool isExpanded = false;
  final _formKey = GlobalKey<FormState>();

  String name = "Alara";
  String skillsOffered = "Flutter, Dart";
  String skillsRequired = "Firebase, Backend";
  String ratings = "⭐⭐⭐⭐☆";
  String education = "B.Tech";
  String location = "India";
  String profession = "Student";

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Widget _buildEditableField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15, fontWeight: FontWeight.w500)),
          TextFormField(
            initialValue: initialValue,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            ),
            validator: isRequired
                ? (val) => val == null || val.trim().isEmpty ? '$label is required' : null
                : null,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Main swipeable card layout
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
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
                      
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage('assets/avatar.png') as ImageProvider,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold)),
                                const Text("Student", style: TextStyle(fontSize: 16)),
                              ],
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
                      const SizedBox(height: 15),
                      const Divider(thickness: 1.5),
                      const SizedBox(height: 25),
                      // Basic info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Skills Offered:", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                          Text(skillsOffered),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Skills Required:", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                          Text(skillsRequired),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Ratings:", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                          Text(ratings),
                        ],
                      ),
                      if (isExpanded) ...[
                        const Divider(thickness: 1),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Education:", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                            Text(education),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Location:", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                            Text(location),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Profession:", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                            Text(profession),
                          ],
                        ),
                      ],
                      const Spacer(),
                    ],
                  ),
                ),
              ),
        
              // Tinder-style action buttons
              Positioned(
                bottom: 45,
                left: 130,
                child: FloatingActionButton(
                  heroTag: 'reject',
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    // Reject logic here
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, size: 30,color: Colors.white,),
                ),
              ),
              Positioned(
                bottom: 45,
                right: 130,
                child: FloatingActionButton(
                  heroTag: 'accept',
                  backgroundColor: Colors.green,
                  onPressed: () {
                    _saveForm(); // or match logic
                  },
                  child: const Icon(Icons.check, size: 28,color: Colors.white,),
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
      )
    );
  }
}
