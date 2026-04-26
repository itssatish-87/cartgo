import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/widget/logout.dart'; // 🔥 IMPORT ADD

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {

  List merchants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingMerchants();
  }

  // 🔥 FETCH PENDING MERCHANTS
  Future<void> fetchPendingMerchants() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.0.2.2:5000/pending-merchants"),
      );

      final data = jsonDecode(res.body);

      setState(() {
        merchants = data;
        isLoading = false;
      });

    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  // ✅ APPROVE
  Future<void> approveMerchant(String email) async {
    await http.post(
      Uri.parse("http://10.0.2.2:5000/approve-merchant"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Approved ✅")),
    );

    fetchPendingMerchants();
  }

  // ❌ REJECT
  Future<void> rejectMerchant(String email) async {
    await http.post(
      Uri.parse("http://10.0.2.2:5000/reject-merchant"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rejected ❌")),
    );

    fetchPendingMerchants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [

          // 🔄 REFRESH
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchPendingMerchants,
          ),

          // 🔥 LOGOUT (FIXED)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout(context); // ✅ FIXED HERE
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : merchants.isEmpty
          ? const Center(
        child: Text(
          "No Pending Merchants 🎉",
          style: TextStyle(fontSize: 16),
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchPendingMerchants,
        child: ListView.builder(
          itemCount: merchants.length,
          itemBuilder: (context, index) {

            final merchant = merchants[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    // 🔥 NAME
                    Text(
                      merchant["name"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // 🔥 EMAIL
                    Text("📧 ${merchant["email"]}"),

                    // 🔥 SHOP
                    Text("🏪 ${merchant["shopName"] ?? ""}"),

                    const SizedBox(height: 10),

                    // 🔥 BUTTONS
                    Row(
                      children: [

                        // ✅ APPROVE
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              approveMerchant(merchant["email"]);
                            },
                            child: const Text("Approve"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ❌ REJECT
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              rejectMerchant(merchant["email"]);
                            },
                            child: const Text("Reject"),
                          ),
                        ),
                      ],
                    )
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