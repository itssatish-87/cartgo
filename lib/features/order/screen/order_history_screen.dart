import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/order_provider.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email") ?? "";

    await Provider.of<OrderProvider>(context, listen: false)
        .fetchOrders(email);
  }

  // 🔥 STATUS COLOR
  Color getStatusColor(String status, bool isCancelled, bool isReturned) {
    if (isCancelled) return Colors.red;
    if (isReturned) return Colors.orange;

    switch (status) {
      case "Placed":
        return Colors.grey;

      case "Processing":
        return Colors.deepPurple;

      case "Shipped":
        return Colors.blue;

      case "Out for Delivery":
        return Colors.teal;

      case "Delivered":
        return Colors.green;

      default:
        return Colors.black;
    }
  }

  // 🔥 STATUS TEXT
  String getStatusText(order) {
    if (order.isCancelled) return "Cancelled";
    if (order.isReturned) return "Returned";
    return order.status;
  }

  @override
  Widget build(BuildContext context) {

    final orders = Provider.of<OrderProvider>(context).orders;

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),

      body: RefreshIndicator(
        onRefresh: loadOrders,
        child: orders.isEmpty
            ? const Center(child: Text("No orders yet"))
            : ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orders.length,
          itemBuilder: (context, index) {

            final order = orders[index];

            final product = order.products.isNotEmpty
                ? order.products[0] as Map<String, dynamic>
                : null;

            final qty = product?["quantity"] ?? 1;

            final total = product != null
                ? (product["price"] * qty)
                : 0;

            final statusText = getStatusText(order);

            final statusColor = getStatusColor(
              order.status,
              order.isCancelled,
              order.isReturned,
            );

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(
                      order: order,
                      index: index,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Row(
                  children: [

                    // 🔥 IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: product != null
                          ? Image.network(
                        product["image"],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image),
                      )
                          : const Icon(Icons.image, size: 50),
                    ),

                    const SizedBox(width: 12),

                    // 🔥 DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Text(
                            product?["name"] ?? "No Product",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "₹${product?["price"] ?? 0} x $qty",
                            style: const TextStyle(fontSize: 13),
                          ),

                          Text(
                            "Total: ₹$total",
                            style: const TextStyle(fontSize: 13),
                          ),

                          Text(
                            "Shop: ${order.shopName}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔥 STATUS CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}