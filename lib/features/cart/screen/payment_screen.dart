import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/model/product_model.dart';
import '../model/address_model.dart';
import '../model/cart_model.dart';
import 'order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<Product> products;
  final Address address;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.products,
    required this.address,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String selectedPayment = "COD";

  final TextEditingController couponController = TextEditingController();

  double discount = 0;
  String appliedCoupon = "";
  bool isLoading = false;

  void applyCoupon(String code) {
    if (code == "SAVE10") {
      setState(() {
        appliedCoupon = code;
        discount = 0.10;
      });
    } else if (code == "FLAT50") {
      setState(() {
        appliedCoupon = code;
        discount = 50;
      });
    } else {
      setState(() {
        appliedCoupon = "";
        discount = 0;
      });
    }
  }

  void removeCoupon() {
    setState(() {
      appliedCoupon = "";
      discount = 0;
      couponController.clear();
    });
  }

  // 🔥 FINAL FIXED ORDER FUNCTION
  Future<void> placeOrder() async {

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email") ?? "";

    try {

      Map<String, List<Map<String, dynamic>>> shopWiseProducts = {};

      for (var product in widget.products) {
        String shop = product.shopName;

        if (!shopWiseProducts.containsKey(shop)) {
          shopWiseProducts[shop] = [];
        }

        shopWiseProducts[shop]!.add({
          "name": product.name,
          "price": product.price,
          "image": product.image,
          "shopName": product.shopName,
          "quantity": product.quantity ?? 1,
        });
      }

      for (var entry in shopWiseProducts.entries) {

        final res = await http.post(
          Uri.parse("http://10.0.2.2:5000/place-order"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "shopName": entry.key,
            "products": entry.value,
            "totalAmount": entry.value.fold(
              0,
                  (sum, item) =>
              sum + ((item["price"] as num) * (item["quantity"] ?? 1)).toInt(),
            ),
            "address": widget.address.address,
          }),
        );

        print("RESPONSE: ${res.body}");

        if (res.statusCode != 200) {
          throw Exception("Order failed");
        }
      }

      // ✅ SUCCESS
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order Placed ✅")),
      );

      Provider.of<CartModel>(context, listen: false).clearCart();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderSuccessScreen(),
        ),
            (route) => false,
      );

    } catch (e) {

      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order Failed ❌")),
      );

    } finally {
      setState(() => isLoading = false); // 🔥 NO STUCK FIX
    }
  }

  @override
  Widget build(BuildContext context) {

    double delivery = 40;

    double itemsTotal = 0;

    for (var item in widget.products) {
      final qty = item.quantity ?? 1;
      itemsTotal += item.price * qty;
    }

    double finalPrice;

    if (discount < 1) {
      finalPrice = itemsTotal + delivery - (itemsTotal * discount);
    } else {
      finalPrice = itemsTotal + delivery - discount;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔹 ADDRESS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Deliver To",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.address.name),
                Text(widget.address.phone),
                Text(widget.address.address),
              ],
            ),

            const Divider(),

            // 🔹 PRODUCTS
            Expanded(
              child: ListView.builder(
                itemCount: widget.products.length,
                itemBuilder: (context, index) {

                  final item = widget.products[index];
                  final qty = item.quantity ?? 1;

                  return ListTile(
                    leading: Image.network(
                      item.image,
                      width: 50,
                      height: 50,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image),
                    ),
                    title: Text(item.name),
                    subtitle: Text("₹${item.price} x $qty"),
                    trailing: Text("₹${item.price * qty}"),
                  );
                },
              ),
            ),

            // 🔹 COUPON
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: couponController,
                    decoration:
                    const InputDecoration(hintText: "Coupon code"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    applyCoupon(couponController.text);
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),

            if (appliedCoupon.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Applied: $appliedCoupon",
                      style: const TextStyle(color: Colors.green)),
                  TextButton(
                    onPressed: removeCoupon,
                    child: const Text("Remove"),
                  )
                ],
              ),

            const Divider(),

            // 🔹 PAYMENT METHOD
            RadioListTile(
              value: "COD",
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() => selectedPayment = value!);
              },
              title: const Text("Cash on Delivery"),
            ),

            RadioListTile(
              value: "UPI",
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() => selectedPayment = value!);
              },
              title: const Text("UPI"),
            ),

            const Divider(),

            // 🔹 PRICE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Items Total"),
                Text("₹${itemsTotal.toStringAsFixed(0)}"),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Delivery"),
                Text("₹${delivery.toStringAsFixed(0)}"),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Discount"),
                Text("- ₹${discount < 1
                    ? (itemsTotal * discount).toStringAsFixed(0)
                    : discount}"),
              ],
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("₹${finalPrice.toStringAsFixed(0)}"),
              ],
            ),

            const SizedBox(height: 10),

            // 🔥 BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : placeOrder,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  selectedPayment == "COD"
                      ? "Place Order"
                      : "Pay ₹${finalPrice.toStringAsFixed(0)}",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}