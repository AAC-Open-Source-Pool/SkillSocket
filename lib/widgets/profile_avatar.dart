import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barter_system/services/user_service.dart';
import 'package:barter_system/profile.dart';

class ProfileAvatar extends StatefulWidget {
  final double radius;
  final VoidCallback? onTap;
  const ProfileAvatar({Key? key, this.radius = 18, this.onTap}) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String? _imageUrl;
  String? _name;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('profileImage');
      final cachedName = prefs.getString('name');
      if (cached != null && cached.isNotEmpty) {
        setState(() { _imageUrl = cached; _name = cachedName; });
        return;
      }
      final profile = await UserService.getUserProfile();
      final image = profile?['profileImage'] as String?;
      final name = profile?['name'] as String?;
      if (image != null && image.isNotEmpty) {
        await prefs.setString('profileImage', image);
      }
      if (name != null && name.isNotEmpty) {
        await prefs.setString('name', name);
      }
      setState(() { _imageUrl = image; _name = name; });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {
        // default navigation behavior - try to push Profile()
        try {
          Navigator.push(context, MaterialPageRoute(builder: (c) => Profile()));
        } catch (_) {}
      },
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.white,
        backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty ? NetworkImage(_imageUrl!) : null,
        child: (_imageUrl == null || _imageUrl!.isEmpty)
            ? (_name != null && _name!.isNotEmpty ? Text(_name![0].toUpperCase(), style: TextStyle(color: Colors.black, fontSize: widget.radius * 0.9)) : const Icon(Icons.person, color: Colors.black, size: 18))
            : null,
      ),
    );
  }
}
