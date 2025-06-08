import 'package:barter_system/selectcommunity.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // State variable for the selected radio button
  String? _currentWorkingStatus;

  // Define TextEditingControllers for each input field
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _skillsRequiredController =
      TextEditingController();
  final TextEditingController _skillsOfferedController =
      TextEditingController();

  // Dispose of controllers to prevent memory leaks
  @override
  void dispose() {
    _educationController.dispose();
    _professionController.dispose();
    _skillsRequiredController.dispose();
    _skillsOfferedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // UPDATED COLORS FOR A RICHER PURPLE GRADIENT
            colors: [
              Color.fromARGB(255, 182, 12, 188), // Pure Purple (lighter top)
              Color.fromARGB(255, 107, 15, 116), // DarkViolet (darker bottom)
            ],
          ),
        ),
        child: SingleChildScrollView(
          // Made the entire body scrollable
          child: Column(
            children: [
              // Top section: LOGO and APP NAME
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
              const SizedBox(
                  height: 50), // Spacing between top section and card
              // Main white card container
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        // Ensure this matches the darker gradient color for consistency
                        color: Color(0xFF6A0DAD),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Education Field
                    const Text(
                      'Education',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPurpleTextField(_educationController),
                    const SizedBox(height: 25),

                    // Certificates Section (no direct text input)
                    const Text(
                      'Certificates',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCertificatesField(),
                    const SizedBox(height: 25),

                    // Are you currently working? Radio Buttons
                    const Text(
                      'Are you currently working?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
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
                          // Ensure activeColor matches the darker gradient color
                          activeColor: const Color(0xFF6A0DAD),
                        ),
                        const Text(
                          'Yes',
                          style: TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(width: 20),
                        Radio<String>(
                          value: 'No',
                          groupValue: _currentWorkingStatus,
                          onChanged: (String? value) {
                            setState(() {
                              _currentWorkingStatus = value;
                            });
                          },
                          // Ensure activeColor matches the darker gradient color
                          activeColor: const Color.fromARGB(255, 154, 13, 173),
                        ),
                        const Text(
                          'No',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Profession Field
                    const Text(
                      'Profession',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPurpleTextField(_professionController),
                    const SizedBox(height: 25),

                    // Skills Required Field
                    const Text(
                      'Skills Required',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPurpleTextField(_skillsRequiredController),
                    const SizedBox(height: 25),

                    // Skills Offered Field
                    const Text(
                      'Skills offered',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPurpleTextField(_skillsOfferedController),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              const SizedBox(height: 30), // Spacing before the button
              // SKIP Button - Moved to the bottom middle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Retrieve and print all collected data
                      print('SKIP button pressed');
                      print('Education: ${_educationController.text}');
                      print('Profession: ${_professionController.text}');
                      print(
                        'Skills Required: ${_skillsRequiredController.text}',
                      );
                      print(
                        'Skills Offered: ${_skillsOfferedController.text}',
                      );
                      print(
                        'Currently Working: ${_currentWorkingStatus ?? 'Not selected'}',
                      );

                      // Navigate to SelectCommunitiesPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectCommunitiesPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      // Ensure background color matches the darker gradient color
                      backgroundColor: const Color.fromARGB(255, 185, 82, 214),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacing at the very bottom
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the purple text fields - now accepts a controller
  Widget _buildPurpleTextField(TextEditingController controller) {
    return TextFormField(
      controller: controller, // Attach the controller
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE6E6FA), // Lavender color for input fields
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }

  // Helper method for the Certificates field with icons (no direct text input)
  Widget _buildCertificatesField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6FA), // Lavender color
        borderRadius: BorderRadius.circular(15),
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

// Dummy page for navigation - Renamed to SelectCommunitiesPage as per import
