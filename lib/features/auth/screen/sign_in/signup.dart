import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/size_config.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // 🔥 MERCHANT FIELDS
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();

  String role = "user"; // 🔥 DEFAULT

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(8)),

                Image.asset(
                  "assets/images/gocart.png",
                  height: SizeConfig.h(12),
                ),

                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: SizeConfig.font(5),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: SizeConfig.h(4)),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      // NAME
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // EMAIL
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // PASSWORD
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // MOBILE
                      TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Mobile Number",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ADDRESS
                      TextField(
                        controller: addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔥 ROLE SELECT
                      DropdownButtonFormField(
                        value: role,
                        items: const [
                          DropdownMenuItem(value: "user", child: Text("User")),
                          DropdownMenuItem(value: "merchant", child: Text("Merchant")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            role = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Select Role",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔥 MERCHANT EXTRA FIELDS
                      if (role == "merchant") ...[

                        TextField(
                          controller: shopNameController,
                          decoration: const InputDecoration(
                            labelText: "Shop Name",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller: shopAddressController,
                          decoration: const InputDecoration(
                            labelText: "Shop Address",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],

                      const SizedBox(height: 20),

                      // SIGNUP BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {

                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                mobileController.text.isEmpty ||
                                addressController.text.isEmpty) {

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields"),
                                ),
                              );
                              return;
                            }

                            // 🔥 MERCHANT VALIDATION
                            if (role == "merchant" &&
                                (shopNameController.text.isEmpty ||
                                    shopAddressController.text.isEmpty)) {

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Enter shop details"),
                                ),
                              );
                              return;
                            }

                            try {
                              final res = await http.post(
                                Uri.parse("http://10.0.2.2:5000/signup"),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode({
                                  "name": nameController.text,
                                  "email": emailController.text,
                                  "password": passwordController.text,
                                  "mobile": mobileController.text,
                                  "address": addressController.text,
                                  "role": role,

                                  // 🔥 APPROVAL SYSTEM
                                  "status": role == "merchant"
                                      ? "pending"
                                      : "approved",

                                  // 🔥 SHOP DATA
                                  "shopName": role == "merchant"
                                      ? shopNameController.text
                                      : null,

                                  "shopAddress": role == "merchant"
                                      ? shopAddressController.text
                                      : null,
                                }),
                              );

                              final data = jsonDecode(res.body);

                              if (res.statusCode == 200) {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      role == "merchant"
                                          ? "Signup successful! Wait for approval ⏳"
                                          : "Signup Successful ✅",
                                    ),
                                  ),
                                );

                                await Future.delayed(const Duration(seconds: 1));

                                if (!context.mounted) return;

                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(data["error"] ?? "Signup failed"),
                                  ),
                                );
                              }

                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Server Error")),
                              );
                            }
                          },
                          child: const Text("Sign Up"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}