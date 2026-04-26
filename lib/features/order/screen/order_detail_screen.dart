import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/order_model.dart';
import '../provider/order_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  final int index;

   const OrderDetailScreen({
    super.key,
    required this.order,
    required this.index,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  // 🔥 STATUS LIST
  List<String> steps = [
    "Placed",
    "Processing",
    "Shipped",
    "Out for Delivery",
    "Delivered"
  ];

  // 🔥 CURRENT STATUS INDEX
  int getCurrentStep() {
    if (widget.order.isCancelled) return -1;

    switch (widget.order.status) {
      case "Processing":
        return 1;
      case "Shipped":
        return 2;
      case "Out for Delivery":
        return 3;
      case "Delivered":
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {

    final products = widget.order.products;
    final currentStep = getCurrentStep();

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= TRACKING =================
            const Text(
              "Order Tracking",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Column(
              children: List.generate(steps.length, (i) {

                final isDone = i <= currentStep;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Column(
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isDone
                              ? Colors.green
                              : Colors.grey,
                        ),
                        if (i != steps.length - 1)
                          Container(
                            width: 2,
                            height: 40,
                            color: isDone
                                ? Colors.green
                                : Colors.grey,
                          ),
                      ],
                    ),

                    const SizedBox(width: 10),

                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        steps[i],
                        style: TextStyle(
                          fontWeight: isDone
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 25),

            // ================= PRODUCTS =================
            const Text(
              "Products",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...products.map((product) {
              final qty = product["quantity"] ?? 1;
              final total = product["price"] * qty;

              return Card(
                child: ListTile(
                  leading: Image.network(
                    product["image"],
                    width: 50,
                    height: 50,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image),
                  ),
                  title: Text(product["name"]),
                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text("₹${product["price"]} x $qty"),
                      Text("Total: ₹$total"),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // ================= ADDRESS =================
            const Text(
              "Delivery Address",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(widget.order.address["address"] ?? ""),

            const SizedBox(height: 20),

            // ================= STATUS =================
            Text(
              widget.order.isCancelled
                  ? "Cancelled ❌"
                  : widget.order.status,
              style: TextStyle(
                color: widget.order.isCancelled
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // ================= CANCEL =================
            if (!widget.order.isCancelled && currentStep < 2)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Provider.of<OrderProvider>(context,
                        listen: false)
                        .cancelOrder(widget.index);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                          content:
                          Text("Order Cancelled ❌")),
                    );
                  },
                  child: const Text("Cancel Order"),
                ),
              ),

            // ================= RETURN =================
            if (!widget.order.isReturned &&
                !widget.order.isCancelled &&
                widget.order.status == "Delivered")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<OrderProvider>(context,
                        listen: false)
                        .returnOrder(widget.index);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Return Requested 🔁")),
                    );
                  },
                  child: const Text("Return Order"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}