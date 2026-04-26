import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MerchantOrdersScreen extends StatefulWidget {
  final String shopName;

  const MerchantOrdersScreen({super.key, required this.shopName});

  @override
  State<MerchantOrdersScreen> createState() =>
      _MerchantOrdersScreenState();
}

class _MerchantOrdersScreenState
    extends State<MerchantOrdersScreen> {

  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final res = await http.get(
      Uri.parse(
          "http://10.0.2.2:5000/orders-by-shop/${widget.shopName}"),
    );

    final data = jsonDecode(res.body);

    setState(() {
      orders = data;
      isLoading = false;
    });
  }

  Future<void> updateStatus(String id, String status) async {
    await http.put(
      Uri.parse("http://10.0.2.2:5000/update-order/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );

    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {

          final order = orders[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text("Order ID: ${order["_id"]}"),

                  const SizedBox(height: 5),

                  Text("Status: ${order["status"]}"),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children: [

                      ElevatedButton(
                        onPressed: () =>
                            updateStatus(order["_id"], "Processing"),
                        child: const Text("Processing"),
                      ),

                      ElevatedButton(
                        onPressed: () =>
                            updateStatus(order["_id"], "Shipped"),
                        child: const Text("Shipped"),
                      ),

                      ElevatedButton(
                        onPressed: () =>
                            updateStatus(order["_id"], "Delivered"),
                        child: const Text("Delivered"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}