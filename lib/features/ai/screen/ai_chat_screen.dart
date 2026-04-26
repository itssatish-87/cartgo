import 'package:cartgo/features/ai/screen/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/model/product_model.dart';
import '../../cart/model/cart_model.dart';
import '../../cart/screen/checkout_screen.dart';

Future<Map<String, dynamic>> getAIResponse(String message) async {
  final res = await http.post(
    Uri.parse("http://10.0.2.2:5000/chat"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"message": message}),
  );

  return jsonDecode(res.body);
}

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {

  final TextEditingController controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  List<Product> convertProducts(List list) {
    return list.map((e) => Product(
      name: e["name"] ?? "",
      price: (e["price"] as num).toDouble(),
      image: e["image"] ?? "",
      category: e["category"] ?? "",
      shopName: e["shopName"] ?? "",
      quantity: 1,
    )).toList();
  }

  void sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    controller.clear();

    final data = await getAIResponse(text);

    final products = convertProducts(data["products"] ?? []);

    setState(() {
      messages.add({
        "role": "ai",
        "text": data["reply"],
        "products": products,
      });
    });
  }

  Widget bubble(Map msg) {
    final isUser = msg["role"] == "user";

    return Align(
      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          msg["text"],
          style: TextStyle(
              color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget productCard(Product product) {

    final cart = Provider.of<CartModel>(context, listen: false);
    final sub = Provider.of<SubscriptionProvider>(context, listen: false);

    int qty = 1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: 170,
          margin: const EdgeInsets.only(right: 10),
          child: Card(
            child: Column(
              children: [

                Expanded(
                  child: Image.network(product.image),
                ),

                Text(product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),

                Text("₹${product.price}"),

                // QTY
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (qty > 1) setState(() => qty--);
                      },
                    ),
                    Text("$qty"),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => qty++);
                      },
                    ),
                  ],
                ),

                // ADD TO CART
                TextButton(
                  onPressed: () {
                    product.quantity = qty;
                    cart.addToCart(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${product.name} added")),
                    );
                  },
                  child: const Text("Add"),
                ),

                // 🔥 SUBSCRIBE
                TextButton(
                  onPressed: () {
                    sub.addSubscription(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${product.name} subscribed 🔁")),
                    );
                  },
                  child: const Text("Subscribe"),
                ),

                // BUY
                ElevatedButton(
                  onPressed: () {
                    product.quantity = qty;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CheckoutScreen(product: product),
                      ),
                    );
                  },
                  child: const Text("Buy"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("AI Assistant 🤖")),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {

                final msg = messages[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    bubble(msg),

                    if (msg["products"] != null)
                      SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: msg["products"].length,
                          itemBuilder: (context, i) {
                            return productCard(
                                msg["products"][i]);
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText:
                      "Try: milk / tshirt / under 500 / diet",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}