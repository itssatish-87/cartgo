import 'package:cartgo/features/auth/screen/login/login.dart';
import 'package:cartgo/features/profile/screen/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cart/screen/saved_address_screen.dart';
import '../../order/screen/order_history_screen.dart';
import '../widget/profile_header.dart';
import '../widget/profile_option.dart';
import '../widget/order_status_card.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name = "";
  String email = "";
  String mobile = "";
  String address = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      mobile = prefs.getString("mobile") ?? "";
      address = prefs.getString("address") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(
            children: [

              // 🔥 USER DATA PASS
              ProfileHeader(
                name: name,
                email: email,
              ),

              const OrderStatusCard(),

              ProfileOption(
                icon: Icons.shopping_bag_outlined,
                title: "Order History",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen(),
                    ),
                  );
                },
              ),
              ProfileOption(
                icon: Icons.repeat,
                title: "My Subscriptions",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SubscriptionScreen(),
                    ),
                  );
                },
              ),

              ProfileOption(
                icon: Icons.edit,
                title: "Edit Profile",
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(name: name,
                        mobile: mobile, address: address,
                      ),
                    ),
                  );

                  loadUser(); // 🔥 refresh after edit
                },
              ),

              ProfileOption(
                icon: Icons.location_on_outlined,
                title: "Saved Addresses",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SavedAddressScreen(),
                    ),
                  );
                },
              ),

              ProfileOption(
                icon: Icons.payment_outlined,
                title: "Payment Methods",
                onTap: () {},
              ),

              ProfileOption(
                icon: Icons.support_agent,
                title: "Help & Support",
                onTap: () {},
              ),

              ProfileOption(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {},
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    debugPrint("logout button clicked");

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                    );
                  },
                  child: const Text("Logout"),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}