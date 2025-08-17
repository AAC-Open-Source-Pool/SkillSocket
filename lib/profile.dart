import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barter_system/notification.dart';
import 'package:barter_system/services/user_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isSaving = false;

  // Declare TextEditingControllers for each input field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController =
      TextEditingController(); // For Date of Birth
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile from backend
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userProfile = await UserService.getUserProfile();

      if (userProfile != null) {
        setState(() {
          _nameController.text = userProfile['name'] ?? '';
          _phoneController.text = userProfile['phone'] ?? '';
          _locationController.text = userProfile['location'] ?? '';
          _bioController.text = userProfile['bio'] ?? '';

          // Handle date of birth
          if (userProfile['dateOfBirth'] != null) {
            final date = DateTime.parse(userProfile['dateOfBirth']);
            _dobController.text = "${date.day}/${date.month}/${date.year}";
          }

          // Handle skills array
          if (userProfile['skills'] != null && userProfile['skills'] is List) {
            _skillsController.text = (userProfile['skills'] as List).join(', ');
          }

          // Handle profile image
          if (userProfile['profileImage'] != null) {
            // You can implement network image loading here if needed
          }
        });
      } else {
        // If profile loading fails, show default values or error
        _initializeDefaultProfile();
      }
    } catch (e) {
      print('Error loading profile: $e');
      _initializeDefaultProfile();
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Initialize profile with default values (fallback)
  void _initializeDefaultProfile() {
    _nameController.text = "";
    _phoneController.text = "";
    _locationController.text = "";
    _bioController.text = "";
    _dobController.text = "";
    _skillsController.text = "";
  }

  // This function will be called when the Save button is clicked.
  Future<void> _saveProfileData() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Parse date of birth from DD/MM/YYYY to ISO format
      String? dateOfBirth;
      if (_dobController.text.isNotEmpty) {
        final parts = _dobController.text.split('/');
        if (parts.length == 3) {
          final day = parts[0].padLeft(2, '0');
          final month = parts[1].padLeft(2, '0');
          final year = parts[2];
          dateOfBirth = '$year-$month-$day';
        }
      }

      // Parse skills from comma-separated string to list
      List<String>? skills;
      if (_skillsController.text.isNotEmpty) {
        skills = _skillsController.text
            .split(',')
            .map((skill) => skill.trim())
            .where((skill) => skill.isNotEmpty)
            .toList();
      }

      final updatedUser = await UserService.updateUserProfile(
        name: _nameController.text.isEmpty ? null : _nameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        location:
            _locationController.text.isEmpty ? null : _locationController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        dateOfBirth: dateOfBirth,
        skills: skills,
        // profileImage: // Add image upload functionality later
      );

      if (updatedUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving profile. Please check your connection.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _isSaving = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // In a real app, you'd likely save this image to a persistent storage
      // (e.g., local storage, cloud storage) and update a data model.
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _usernameController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  // Helper method to build each profile input field
  Widget _buildProfileInputField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false, // To make Date of Birth field read-only
    VoidCallback? onTap, // For Date of Birth picker
    Color fillColor = const Color(0xFFC0A2C2), // Default light purple
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54, // Label text color
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(
                color: Color.fromARGB(
                    255, 147, 52, 134)), // Text color inside the field
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor, // Background color of the text field
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none, // No border line
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              // You can add a hintText if needed, e.g., hintText: 'Enter your $label',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF56195B), // AppBar background color
        iconTheme: const IconThemeData(color: Colors.white), // Icons on AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notifications()),
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF56195B),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading your profile...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : null,
                          child: _imageFile == null
                              ? const Icon(Icons.person,
                                  size: 70, color: Colors.white70)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Color(0xFF56195B), // Camera icon color
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Profile Input Fields ---
                  _buildProfileInputField(
                    label: 'Name',
                    controller: _nameController,
                  ),
                  _buildProfileInputField(
                    label: 'Phone',
                    controller: _phoneController,
                  ),

                  // Date of Birth field with date picker
                  _buildProfileInputField(
                    label: 'Date of Birth',
                    controller: _dobController,
                    readOnly: true, // Make it read-only
                    fillColor: const Color.fromARGB(
                        255, 214, 164, 214), // Darker purple for DOB
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(
                                    0xFF56195B), // Header background color of date picker
                                onPrimary: Colors
                                    .white, // Header text color of date picker
                                onSurface: Colors
                                    .black, // Body text color of date picker
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(
                                      0xFF56195B), // Button text color in date picker
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          // Format the date as DD/MM/YYYY
                          _dobController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                  ),

                  // Ratings section (Static as per image, no input field)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ratings',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < 4
                                  ? Colors.green[700]
                                  : Colors.grey[400], // 4 filled stars, 1 empty
                              size: 24,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  _buildProfileInputField(
                    label: 'Location',
                    controller: _locationController,
                  ),
                  _buildProfileInputField(
                    label: 'Bio',
                    controller: _bioController,
                  ),
                  _buildProfileInputField(
                    label: 'Skills (comma-separated)',
                    controller: _skillsController,
                  ),

                  const SizedBox(height: 40), // Add some space at the bottom

                  // Save Button
                  Center(
                    // Center the button horizontally
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : _saveProfileData, // Disable when saving
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF56195B), // Button background color
                          foregroundColor: Colors.white, // Button text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded corners
                          ),
                          elevation: 5, // Add a little shadow
                          minimumSize:
                              const Size(120, 45), // Make the button smaller
                        ),
                        child: _isSaving
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Saving...',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Save', // Text is "Save"
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space after the button
                ],
              ),
            ),
    );
  }
}
