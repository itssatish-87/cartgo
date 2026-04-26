import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {

  final nameController = TextEditingController();
  final imageController = TextEditingController();
  final categoryController = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading = false;

  Future<void> addShop() async {

    if (nameController.text.isEmpty ||
        imageController.text.isEmpty ||
        categoryController.text.isEmpty ||
        addressController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {

      // 🔥 GET LOGGED-IN USER EMAIL
      final prefs = await SharedPreferences.getInstance();
      String email = prefs.getString("email") ?? "";

      final res = await http.post(
        Uri.parse("http://10.0.2.2:5000/add-shop"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text,
          "image": imageController.text,
          "category": categoryController.text,
          "address": addressController.text,
          "ownerEmail": email, // 🔥 IMPORTANT
        }),
      );

      if (res.statusCode == 200) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Shop Added ✅")),
        );

        Navigator.pop(context);

      } else {
        throw Exception("Failed");
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error adding shop ❌")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Shop")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Shop Name"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : addShop,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add Shop"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}