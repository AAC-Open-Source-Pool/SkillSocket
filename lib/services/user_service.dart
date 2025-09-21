import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl =
      'http://localhost:3000/api'; // Local backend for development

  // Get headers with authentication token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print(
        '🔑 UserService - Retrieved token: ${token != null ? 'Token exists' : 'No token'}');

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final headers = await _getHeaders();

      print('Making GET request to: $baseUrl/user/profile'); // Debug log
      print('With headers: $headers'); // Debug log

      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: headers,
      );

      print('Get profile response status: ${response.statusCode}'); // Debug log
      print('Get profile response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['user']; // Return the user object
      } else {
        print('Get profile error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Get profile exception: $e');
      return null;
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>?> updateUserProfile({
    String? name,
    String? phone,
    String? bio,
    String? location,
    String? dateOfBirth,
    List<String>? skills,
    String? profileImage,
    String? education,
    String? profession,
    String? currentlyWorking,
    List<String>? skillsRequired,
    List<String>? skillsOffered,
  }) async {
    try {
      final headers = await _getHeaders();

      // Build the update data
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (bio != null) updateData['bio'] = bio;
      if (location != null) updateData['location'] = location;
      if (dateOfBirth != null) updateData['dateOfBirth'] = dateOfBirth;
      if (skills != null) updateData['skills'] = skills;
      if (profileImage != null) updateData['profileImage'] = profileImage;
      if (education != null) updateData['education'] = education;
      if (profession != null) updateData['profession'] = profession;
      if (currentlyWorking != null)
        updateData['currentlyWorking'] = currentlyWorking;
      if (skillsRequired != null) updateData['skillsRequired'] = skillsRequired;
      if (skillsOffered != null) updateData['skillsOffered'] = skillsOffered;

      print('Making PUT request to: $baseUrl/user/profile'); // Debug log
      print('With headers: $headers'); // Debug log
      print('With body: ${json.encode(updateData)}'); // Debug log

      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: headers,
        body: json.encode(updateData),
      );

      print(
          'Update profile response status: ${response.statusCode}'); // Debug log
      print('Update profile response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['user']; // Return the updated user object
      } else {
        print(
            'Update profile error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Update profile exception: $e');
      return null;
    }
  }

  // Upload user logo
  static Future<String?> uploadUserLogo(File logoFile) async {
    try {
      final token = await _getHeaders();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/user/upload-logo'),
      );

      // Add authorization header
      if (token['Authorization'] != null) {
        request.headers['Authorization'] = token['Authorization']!;
      }

      // Add the file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'logo',
          logoFile.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['logoUrl'];
      } else {
        print('Logo upload error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Logo upload exception: $e');
      return null;
    }
  }
}
