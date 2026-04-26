import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/product_model.dart';
import '../../cart/model/cart_model.dart';
import 'address.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Product>? products;
  final Product? product;

  const CheckoutScreen({
    super.key,
    this.products,
    this.product,
  });

  @override
  Widget build(BuildContext context) {

    final cart = context.watch<CartModel>();

    // 🔥 FINAL ITEMS LIST
    final List<Product> items =
        products ??
            (product != null ? [product!] : cart.cartItems);

    double delivery = 40;
    double total = 0;

    for (var item in items) {
      total += item.price * (item.quantity ?? 1);
    }

    double finalAmount = total + delivery;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 🔥 PRODUCT LIST
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {

                  final item = items[index];
                  final qty = item.quantity ?? 1;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
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
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Price Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Items Total"),
                Text("₹${total.toStringAsFixed(0)}"),
              ],
            ),

            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Delivery Charges"),
                Text("₹${delivery.toStringAsFixed(0)}"),
              ],
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹${finalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 🔥 CONTINUE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddressScreen(
                        products: items,
                        totalAmount: finalAmount,
                      ),
                    ),
                  );

                },
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}