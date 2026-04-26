import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/cart_model.dart';
import '../screen/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: cart.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
        children: [

          // 🔹 Cart Items
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                final item = cart.cartItems[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network( // ✅ FIXED
                      item.image,
                      width: 50,
                      height: 50,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image),
                    ),
                    title: Text(item.name),
                    subtitle: Text("₹${item.price}"),

                    // 🔥 QUANTITY CONTROL
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            cart.decreaseQty(index);
                          },
                        ),

                        Text(item.quantity.toString()),

                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cart.increaseQty(index);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () {
                            cart.removeFromCart(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 Bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 5, color: Colors.black12)
              ],
            ),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹${cart.totalPrice}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          CheckoutScreen(),
                        ),
                      );
                    },
                    child: const Text("Checkout",
                        style:
                        TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}