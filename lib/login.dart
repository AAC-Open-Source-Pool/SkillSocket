import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barter_system/home.dart';
import 'package:barter_system/signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'App Name')),
      );
    } catch (e) {
      print("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white70,
                child: Text("LOGO", style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 12),
              const Text("BARTER SYSTEM",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("LOGIN",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text("Please sign in to continue"),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFE8CFF7),
                        prefixIcon: Icon(Icons.person),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFE8CFF7),
                        prefixIcon: Icon(Icons.key),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Forgot password?"),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4B014B),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: loginUser,
                        child: const Text("LOGIN",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Don’t have an account? "),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignUpScreen()));
                },
                child: const Text("Sign Up",
                    style: TextStyle(
                        color: Color(0xFFE8CFF7),
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
