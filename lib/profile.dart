import 'package:flutter/material.dart';
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile',style: TextStyle(fontSize: 32,fontStyle: FontStyle.italic,color: Color.fromARGB(255, 255, 255, 255)),),
        backgroundColor:Color(0xFF56195B),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
    );
  }
}
