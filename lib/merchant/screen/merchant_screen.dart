import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/widget/logout.dart';
import '../../features/store/localshop/screen/shop_product_screen.dart';
import 'add_product_merchant_screen.dart';
import 'merchant_orders_screen.dart'; // 🔥 NEW

class MerchantScreen extends StatefulWidget {
  final String shopName;

  const MerchantScreen({super.key, required this.shopName});

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {

  int productCount = 0;
  int totalOrders = 0;
  double totalSales = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.0.2.2:5000/merchant-stats/${widget.shopName}"),
      );

      print("STATUS CODE: ${res.statusCode}");
      print("BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          productCount = data["productCount"] ?? 0;
          totalOrders = data["totalOrders"] ?? 0;
          totalSales = (data["totalSales"] ?? 0).toDouble();
          isLoading = false;
        });
      } else {
        throw Exception("API Failed");
      }

    } catch (e) {
      print("ERROR: $e");

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data")),
      );
    }
  }

  Widget statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Merchant Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchStats,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🏪 SHOP
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.store, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.shopName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📊 STATS
            Row(
              children: [
                statCard("Products", "$productCount", Icons.inventory),
                statCard("Orders", "$totalOrders", Icons.shopping_cart),
                statCard("Sales", "₹$totalSales", Icons.currency_rupee),
              ],
            ),

            const SizedBox(height: 20),

            // ➕ ADD PRODUCT
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductMerchantScreen(
                      shopName: widget.shopName,
                    ),
                  ),
                );
                fetchStats();
              },
            ),

            const SizedBox(height: 10),

            // 📦 MANAGE PRODUCTS
            OutlinedButton.icon(
              icon: const Icon(Icons.inventory),
              label: const Text("Manage Products"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShopProductScreen(
                      shopName: widget.shopName,
                      ownerEmail: "",
                    ),
                  ),
                );
                fetchStats();
              },
            ),

            const SizedBox(height: 10),

            // 🔥 NEW: VIEW ORDERS
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_bag),
              label: const Text("View Orders"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MerchantOrdersScreen(
                      shopName: widget.shopName,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}