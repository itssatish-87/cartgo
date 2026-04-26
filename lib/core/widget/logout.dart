import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/screen/login/login.dart';

Future<void> logout(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // 🔥 CLEAR ALL SESSION DATA
    await prefs.clear();

    if (!context.mounted) return;

    // 🔥 NAVIGATE TO LOGIN (REMOVE ALL SCREENS)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );

  } catch (e) {
    debugPrint("Logout Error: $e");
  }
}