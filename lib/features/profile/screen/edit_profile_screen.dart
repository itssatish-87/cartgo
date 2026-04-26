import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String mobile;
  final String address;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.mobile,
    required this.address,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    // 🔥 PREFILL DATA
    _nameController =
        TextEditingController(text: widget.name);
    _mobileController =
        TextEditingController(text: widget.mobile);
    _addressController =
        TextEditingController(text: widget.address);
  }

  Future<void> updateProfile() async {

    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email") ?? "";

    try {
      final res = await http
          .put(
        Uri.parse("http://10.0.2.2:5000/update-user"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "name": _nameController.text,
          "mobile": _mobileController.text,
          "address": _addressController.text,
        }),
      )
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {

        // 🔥 LOCAL UPDATE
        await prefs.setString("name", _nameController.text);
        await prefs.setString("mobile", _mobileController.text);
        await prefs.setString("address", _addressController.text);

        if (!mounted) return; // 🔥 IMPORTANT FIX

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated ✅")),
        );

        Navigator.pop(context);

      } else {

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update Failed")),
        );
      }

    } catch (e) {
      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔥 NAME (same UI)
            TextField(
              controller: _nameController,
              decoration:
              const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 20),

            // 🔥 MOBILE (email replace)
            TextField(
              controller: _mobileController,
              decoration:
              const InputDecoration(labelText: "Mobile"),
            ),

            const SizedBox(height: 20),

            // 🔥 ADDRESS (new)
            TextField(
              controller: _addressController,
              decoration:
              const InputDecoration(labelText: "Address"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {

                // 🔥 VALIDATION
                if (_nameController.text.isEmpty ||
                    _mobileController.text.isEmpty ||
                    _addressController.text.isEmpty) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Fill all fields")),
                  );
                  return;
                }

                updateProfile();
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}