import 'package:barter_system/signup2.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String gender = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Navigate to next page with form data
  void _goToNextPage() {
    if (_formKey.currentState!.validate() && gender.isNotEmpty) {
      final userData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'dateOfBirth': _dobController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'gender': gender,
        'location': _locationController.text.trim(),
        'password': _passwordController.text,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SignUpPage(userData: userData),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Please fill all required fields and select gender';
      });
    }
  }

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
                const Text("BARTER SYSTEM",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sign Up",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),

                        // Error Message
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
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

                        const Text('First Name *',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 8),
                        buildValidatedTextField(
                            _firstNameController, "First Name",
                            validator: (value) =>
                                _validateName(value, "First name")),

                        const Text('Last Name *',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 8),
                        buildValidatedTextField(
                            _lastNameController, "Last Name",
                            validator: (value) =>
                                _validateName(value, "Last name")),

                        const Text('Date of Birth *',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 8),
                        buildDateField(),

                        const Text('E-Mail *',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 8),
                        buildValidatedTextField(_emailController, "Email",
                            validator: _validateEmail,
                            keyboardType: TextInputType.emailAddress),

                        const Text('Password *',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 8),
                        buildValidatedTextField(_passwordController, "Password",
                            validator: _validatePassword, obscureText: true),

                        const Text('Confirm Password *',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 8),
                        buildValidatedTextField(
                            _confirmPasswordController, "Confirm Password",
                            validator: _validateConfirmPassword,
                            obscureText: true),

                        const Text("Gender *",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        Row(
                          children: [
                            Radio(
                              value: 'Male',
                              groupValue: gender,
                              onChanged: (value) =>
                                  setState(() => gender = value!),
                            ),
                            const Text("Male"),
                            Radio(
                              value: 'Female',
                              groupValue: gender,
                              onChanged: (value) =>
                                  setState(() => gender = value!),
                            ),
                            const Text("Female"),
                          ],
                        ),
                        const SizedBox(height: 20),

                        const Text('Location *',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 8),
                        buildValidatedTextField(
                            _locationController, "Location"),

                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _goToNextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4B014B),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text("NEXT",
                                    style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildValidatedTextField(
    TextEditingController controller,
    String hint, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE8CFF7),
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
          ),
        ),
      ),
    );
  }

  Widget buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          controller: _dobController,
          readOnly: true,
          onTap: _selectDate,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Date of birth is required';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE8CFF7),
            hintText: "Select Date of Birth",
            suffixIcon: const Icon(Icons.calendar_today),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
          ),
        ),
      ),
    );
  }
}
