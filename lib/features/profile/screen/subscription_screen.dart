import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ai/screen/subscription_provider.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final subProvider = Provider.of<SubscriptionProvider>(context);
    final subs = subProvider.subs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Subscriptions 🔁"),
      ),

      body: subs.isEmpty
          ? const Center(child: Text("No subscriptions yet"))
          : ListView.builder(
        itemCount: subs.length,
        itemBuilder: (context, index) {

          final product = subs[index];

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            child: ListTile(

              leading: Image.network(
                product.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image),
              ),

              title: Text(product.name),

              subtitle: Text("₹${product.price}"),

              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  subProvider.removeSubscription(index);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Subscription removed ❌"),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}