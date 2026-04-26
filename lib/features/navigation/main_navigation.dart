import 'package:cartgo/features/grocery/screen/grocery.dart';
import 'package:cartgo/features/profile/screen/profile_screen.dart';
import 'package:cartgo/features/store/screen/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../ai/screen/ai_chat_screen.dart';
import '../home/screen/home.dart';

class MainNavigation extends StatefulWidget {
  final String userName;
  const MainNavigation({super.key, required this.userName});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int _selectedIndex = 0;

  // 🔹 Pages list
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(userName: widget.userName),
      const StoreScreen(),
      const AIChatScreen(),
      const GroceryScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // 🔹 Top Divider Line
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade400,
          ),

          // 🔹 Bottom Navigation Bar
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed, // 👈 important
            backgroundColor: Colors.white, // 👈 IMPORTANT
            elevation: 10,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.shopping_cart5),
                label: "Store",
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.microphone),
                label: "AI",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_grocery_store),
                label: "Grocery",
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: "Profile",
              ),
            ],
          ),
        ],
      ),

    );
  }
}
