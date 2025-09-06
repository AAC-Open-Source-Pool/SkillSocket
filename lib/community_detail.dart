import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // for formatting creation date
import 'package:barter_system/models/communityb.dart';

class CommunityDetailPage extends StatelessWidget {
  final BackendCommunity community;

  const CommunityDetailPage({Key? key, required this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format creation date (assuming community.createdAt is DateTime)
    final creationDate = community.createdAt != null
        ? DateFormat.yMMMMd().format(community.createdAt!)
        : "Unknown";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(community.name,style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Color(0xFF56195B),
        elevation: 0,
        iconTheme:IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
            colors: [Color(0xFF56195B), Color.fromARGB(255, 167, 35, 193),Color.fromARGB(255, 215, 154, 223)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: community.iconUrl != null
                        ? FileImage(File(community.iconUrl!))
                        : null,
                    child: community.iconUrl == null
                        ? Icon(Icons.groups, size: 50, color: Colors.deepPurple)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    community.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    community.bio ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () {
                      // join logic
                    },
                    icon: const Icon(Icons.person_add_alt),
                    label: const Text("Join Community"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tags",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.start, 
                    spacing: 8,
                    runSpacing: 8,
                    children: community.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.deepPurple.shade50,
                              labelStyle:
                                  const TextStyle(color: Colors.deepPurple),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Members + Created Date Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Community Info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.people, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        "${community.memberCount} members", // <-- fixed field name
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        // Remove or update this if you don't have createdAt
                        "Created on Unknown",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Posts Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Posts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.post_add),
                      title: Text("This is a sample post"),
                      subtitle: Text("Posted by member"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
