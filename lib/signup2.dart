import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:barter_system/selectcommunity.dart';

class SignUpPage extends StatefulWidget {
  final Map<String, String>? userData;

  const SignUpPage({super.key, this.userData});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _currentWorkingStatus;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _skillsRequiredController =
      TextEditingController();
  final TextEditingController _skillsOfferedController =
      TextEditingController();

  @override
  void dispose() {
    _educationController.dispose();
    _professionController.dispose();
    _skillsRequiredController.dispose();
    _skillsOfferedController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  Future<void> _submitSignup() async {
    if (!_formKey.currentState!.validate() || _currentWorkingStatus == null) {
      setState(() {
        _errorMessage = 'Please fill all required fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Combine data from both pages
      final signupData = {
        'firstName': widget.userData?['firstName'] ?? '',
        'lastName': widget.userData?['lastName'] ?? '',
        'email': widget.userData?['email'] ?? '',
        'password': widget.userData?['password'] ?? '',
        'dateOfBirth': widget.userData?['dateOfBirth'] ?? '',
        'gender': widget.userData?['gender'] ?? '',
        'location': widget.userData?['location'] ?? '',
        'education': _educationController.text.trim(),
        'currentlyWorking': _currentWorkingStatus,
        'profession': _professionController.text.trim(),
        'skillsRequired': _skillsRequiredController.text
            .trim()
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        'skillsOffered': _skillsOfferedController.text
            .trim()
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
      };

      print('Sending signup data: $signupData');

      final response = await http.post(
        Uri.parse('https://app-backend-latest-vzas.onrender.com/api/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(signupData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['success'] == true) {
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to community selection
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SelectCommunitiesPage()),
          );
        }
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Registration failed';
        });
      }
    } catch (e) {
      print('Signup error: $e');
      setState(() {
        _errorMessage =
            'Network error. Please check your connection and ensure the backend server is running.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD6A4A4), Color(0xFF5C1A82)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 20.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: const Center(
                        child: Text(
                          'LOGO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'APP NAME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Error Message
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error,
                                  color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const Text(
                        'Education *',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      _buildPurpleTextField(_educationController,
                          hint: 'Education',
                          validator: (value) =>
                              _validateRequired(value, 'Education')),
                      const SizedBox(height: 25),

                      const Text(
                        'Certificates',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      _buildCertificatesField(),
                      const SizedBox(height: 25),

                      const Text(
                        'Are you currently working? *',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Yes',
                            groupValue: _currentWorkingStatus,
                            onChanged: (String? value) {
                              setState(() {
                                _currentWorkingStatus = value;
                              });
                            },
                            activeColor: const Color(0xFF6A0DAD),
                          ),
                          const Text('Yes',
                              style: TextStyle(color: Colors.black87)),
                          const SizedBox(width: 20),
                          Radio<String>(
                            value: 'No',
                            groupValue: _currentWorkingStatus,
                            onChanged: (String? value) {
                              setState(() {
                                _currentWorkingStatus = value;
                              });
                            },
                            activeColor: Color.fromARGB(255, 154, 13, 173),
                          ),
                          const Text('No',
                              style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 25),

                      const Text(
                        'Profession *',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      _buildPurpleTextField(_professionController,
                          hint: 'Profession',
                          validator: (value) =>
                              _validateRequired(value, 'Profession')),
                      const SizedBox(height: 25),

                      const Text(
                        'Skills Required',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      _buildPurpleTextField(_skillsRequiredController,
                          hint: 'Skills you want to learn (comma separated)'),
                      const SizedBox(height: 25),

                      const Text(
                        'Skills offered',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      _buildPurpleTextField(_skillsOfferedController,
                          hint: 'Skills you can teach (comma separated)'),
                      const SizedBox(height: 50),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4B014B),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text("PREV",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _submitSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4B014B),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text("SUBMIT",
                                      style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Updated to accept hint text and validator
  Widget _buildPurpleTextField(TextEditingController controller,
      {String hint = '', String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        filled: true,
        fillColor: const Color(0xFFE8CFF7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildCertificatesField() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFE8CFF7),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: const Row(
        children: [
          Icon(Icons.camera_alt_outlined, color: Colors.black54),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              'Upload your certificates',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Icon(Icons.upload_file, color: Colors.black54),
        ],
      ),
    );
  }
}
