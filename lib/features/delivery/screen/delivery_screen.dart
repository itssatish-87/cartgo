import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/screen/login/login.dart';

// 🔥 ADD THIS (change path if needed)


class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  List orders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final res = await http.get(
      Uri.parse("http://10.0.2.2:5000/delivery-orders"),
    );

    setState(() {
      orders = jsonDecode(res.body);
      loading = false;
    });
  }

  // 🔥 LOGOUT FUNCTION
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  Future<void> acceptOrder(String id) async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email") ?? "";

    await http.put(
      Uri.parse("http://10.0.2.2:5000/assign-delivery/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"deliveryBoy": email}),
    );

    fetchOrders();
  }

  Future<void> deliverOrder(String id) async {
    await http.put(
      Uri.parse("http://10.0.2.2:5000/deliver-order/$id"),
    );

    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Panel 🚚"),

        // 🔥 LOGOUT BUTTON
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          )
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text("No Orders"))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {

          final order = orders[index];
          final product = order["products"][0];

          // 🔥 ADDRESS FIX
          final address = order["address"];
          String addressText = "";

          if (address is String) {
            addressText = address;
          } else if (address is Map) {
            addressText = address["address"] ?? "";
          }

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(

              title: Text(product["name"] ?? "No Name"),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("₹${product["price"] ?? 0}"),
                  Text("Status: ${order["status"] ?? ""}"),
                  Text("Address: $addressText"),
                ],
              ),

              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if (order["status"] == "Shipped")
                    ElevatedButton(
                      onPressed: () =>
                          acceptOrder(order["_id"]),
                      child: const Text("Accept"),
                    ),

                  if (order["status"] == "Out for Delivery")
                    ElevatedButton(
                      onPressed: () =>
                          deliverOrder(order["_id"]),
                      child: const Text("Delivered"),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}