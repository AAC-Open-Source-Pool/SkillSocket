import 'package:barter_system/selectcommunity.dart';
import 'package:barter_system/signup.dart';
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
  String? _currentWorkingStatus;

  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _skillsRequiredController = TextEditingController();
  final TextEditingController _skillsOfferedController = TextEditingController();

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

                    const Text(
                      'Education *',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    _buildPurpleTextField(_educationController, hint: 'Education'),
                    const SizedBox(height: 25),

                    const Text(
                      'Certificates *',
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
                        const Text('Yes', style: TextStyle(color: Colors.black87)),
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
                        const Text('No', style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 25),

                    const Text(
                      'Profession *',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    _buildPurpleTextField(_professionController, hint: 'Profession'),
                    const SizedBox(height: 25),

                    const Text(
                      'Skills Required',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    _buildPurpleTextField(_skillsRequiredController, hint: 'Skills you want to learn'),
                    const SizedBox(height: 25),

                    const Text(
                      'Skills offered',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    _buildPurpleTextField(_skillsOfferedController, hint: 'Skills you can teach'),
                    const SizedBox(height: 50),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4B014B),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text("PREV", style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print('SKIP button pressed');
                              print('Education: ${_educationController.text}');
                              print('Profession: ${_professionController.text}');
                              print('Skills Required: ${_skillsRequiredController.text}');
                              print('Skills Offered: ${_skillsOfferedController.text}');
                              print('Currently Working: ${_currentWorkingStatus ?? 'Not selected'}');
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCommunitiesPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4B014B),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text("NEXT", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Updated to accept hint text
  Widget _buildPurpleTextField(TextEditingController controller, {String hint = ''}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        filled: true,
        fillColor: const Color(0xFFE8CFF7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
