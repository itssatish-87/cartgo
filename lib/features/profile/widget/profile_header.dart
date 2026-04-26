import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHeader extends StatefulWidget {
  final String name;
  final String email;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {

  String? imageBase64;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  // 🔥 LOAD IMAGE
  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imageBase64 = prefs.getString("profile_image");
    });
  }

  // 🔥 PICK IMAGE
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profile_image", base64Image);

      setState(() {
        imageBase64 = base64Image;
      });
    }
  }

  // ❌ REMOVE IMAGE
  Future<void> removeImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("profile_image");

    setState(() {
      imageBase64 = null;
    });
  }

  // 🔥 SHOW OPTIONS
  void showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Change Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),

              if (imageBase64 != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Remove Photo"),
                  onTap: () {
                    Navigator.pop(context);
                    removeImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    ImageProvider? image;

    if (imageBase64 != null) {
      image = MemoryImage(base64Decode(imageBase64!));
    }

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.deepPurple[300],
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: [

            // 👤 PROFILE IMAGE
            Stack(
              children: [

                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: image,
                  child: image == null
                      ? const Icon(Icons.person,
                      size: 45, color: Colors.deepPurple)
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: showOptions,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 12),

            // 👤 NAME
            Text(
              widget.name.isEmpty ? "User Name" : widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 2),

            // 📧 EMAIL
            Text(
              widget.email.isEmpty ? "user@email.com" : widget.email,
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 12),

            // ⭐ PREMIUM
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "GoCart Premium Member",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}