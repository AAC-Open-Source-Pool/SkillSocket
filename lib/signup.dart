import 'package:barter_system/signup2.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String gender = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white70,
                  child: Text("LOGO", style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 8),
                const Text("BARTER SYSTEM", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Sign Up", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Text(
                      'First Name *',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                      buildTextField("First Name"),
                      const Text(
                      'Last Name *',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                      buildTextField("Last Name"),
                      const Text(
                      'Date of Birth *',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                      buildTextFieldWithIcon("DOB", Icons.calendar_today),
                      const Text(
                      'E-Mail *',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                      buildTextFieldWithButton("Email", "Verify"),
                      const Text(
                      'Phone Number *',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                      buildTextFieldWithButton("Phone number", "Verify"),
                      const Text("Gender *",style: TextStyle(fontSize: 16, color: Colors.black87),),
                      Row(
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (value) => setState(() => gender = value!),
                          ),
                          const Text("Male"),
                          Radio(
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (value) => setState(() => gender = value!),
                          ),
                          const Text("Female"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildDisabledTextField("Location", Icons.location_on, Icons.arrow_drop_down, isEditable: true),
                      const Text(
                      'Profile Picture',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                      buildDisabledTextField("Upload a Photo", Icons.camera_alt, Icons.upload),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4B014B),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("NEXT", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 60,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE8CFF7),
            hintText: label,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldWithIcon(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 60,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE8CFF7),
            hintText: label,
            prefixIcon: Icon(icon),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldWithButton(String label, String buttonText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 60,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFE8CFF7),
                  hintText: label,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B014B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(buttonText, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDisabledTextField(String label, IconData prefixIcon, IconData suffixIcon, {bool isEditable = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 60,
        child: TextField(
          
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE8CFF7),
            hintText: label,
            prefixIcon: Icon(prefixIcon),
            suffixIcon: Icon(suffixIcon),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
