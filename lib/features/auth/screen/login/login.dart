import 'dart:convert';
import 'package:cartgo/features/auth/screen/login/login_form.dart';
import 'package:cartgo/features/navigation/main_navigation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../admin/screen/admin_panel.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../merchant/screen/merchant_screen.dart';
import '../../../delivery/screen/delivery_screen.dart';
import '../sign_in/signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.h(8)),

                // 🔥 LOGO
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/gocart.png",
                        height: SizeConfig.h(12),
                      ),
                      SizedBox(height: SizeConfig.h(1)),

                      Text(
                        "Welcome to GoCart",
                        style: TextStyle(
                          fontSize: SizeConfig.font(5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Fast, Reliable, and Efficient Shipping",
                        style: TextStyle(
                          fontSize: SizeConfig.font(3),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.h(4)),

                // 🔥 LOGIN FORM
                LoginForm(
                  loginType: LoginType.user,

                  onSubmit: (String email, String password) async {

                    // 🔥 ADMIN LOGIN
                    if (email == "admin@gocart.com" &&
                        password == "123456") {

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminPanelScreen(),
                        ),
                            (route) => false,
                      );
                      return;
                    }

                    try {
                      final res = await http.post(
                        Uri.parse("http://10.0.2.2:5000/login"),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({
                          "email": email,
                          "password": password,
                        }),
                      );

                      final data = jsonDecode(res.body);

                      if (res.statusCode == 200) {

                        final prefs =
                        await SharedPreferences.getInstance();

                        // 🔥 SAVE USER DATA
                        await prefs.setBool("isLoggedIn", true);
                        await prefs.setString("userName", data["name"] ?? "");
                        await prefs.setString("role", data["role"] ?? "");
                        await prefs.setString("email", data["email"] ?? "");
                        await prefs.setString("mobile", data["mobile"] ?? "");
                        await prefs.setString("address", data["address"] ?? "");
                        await prefs.setString("shopName", data["shopName"] ?? "");

                        if (!context.mounted) return;

                        // 🔥 ROLE BASED NAVIGATION

                        // 🚚 DELIVERY BOY
                        if (data["role"] == "delivery") {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DeliveryScreen(),
                            ),
                                (route) => false,
                          );
                        }

                        // 🏪 MERCHANT
                        else if (data["role"] == "merchant") {

                          if (data["status"] != "approved") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Your account is under approval ⏳"),
                              ),
                            );
                            return;
                          }

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MerchantScreen(
                                shopName: data["shopName"] ?? "",
                              ),
                            ),
                                (route) => false,
                          );
                        }

                        // 👤 NORMAL USER
                        else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MainNavigation(
                                userName: data["name"] ?? "",
                              ),
                            ),
                                (route) => false,
                          );
                        }

                      } else {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(data["message"] ?? "Login failed"),
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
                ),

                SizedBox(height: SizeConfig.h(1)),

                // 🔥 SIGNUP OPTION
                Center(
                  child: Column(
                    children: [
                      Text("OR",
                          style:
                          TextStyle(fontSize: SizeConfig.font(2))),
                      SizedBox(height: SizeConfig.h(1)),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style:
                          const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "SignUp",
                              style: const TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const SignupScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.h(3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}