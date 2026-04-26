import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/model/product_model.dart';
import '../model/address_model.dart';
import 'payment_screen.dart';


class AddressScreen extends StatefulWidget {
  final List<Product> products;
  final double totalAmount;

  const AddressScreen({
    super.key,
    required this.products,
    required this.totalAmount,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  List<Address> addresses = [];
  Address? selectedAddress;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list = prefs.getStringList("addresses") ?? [];

    setState(() {
      addresses =
          list.map((e) => Address.fromJson(jsonDecode(e))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Address")),

      body: Column(
        children: [

          Expanded(
            child: addresses.isEmpty
                ? const Center(child: Text("No address found"))
                : ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {

                final a = addresses[index];

                return RadioListTile<Address>(
                  value: a,
                  groupValue: selectedAddress,
                  onChanged: (val) {
                    setState(() {
                      selectedAddress = val;
                    });
                  },
                  title: Text(a.name),
                  subtitle: Text("${a.phone}\n${a.address}"),
                );
              },
            ),
          ),

          // 🔥 TOTAL + CONTINUE
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount"),
                    Text("₹${widget.totalAmount}"),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedAddress == null
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            products: widget.products,
                            totalAmount: widget.totalAmount,
                            address: selectedAddress!,
                          ),
                        ),
                      );
                    },
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}