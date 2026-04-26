import 'package:flutter/material.dart';

import '../../core/widget/logout.dart';

class MerchantProfileScreen extends StatelessWidget {
  final String userName;

  const MerchantProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context), // 🔥 LOGOUT
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 40,
              child: Text(
                userName.isNotEmpty ? userName[0] : "U",
                style: const TextStyle(fontSize: 30),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              userName,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // 🔥 LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => logout(context),
                child: const Text("Logout"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}