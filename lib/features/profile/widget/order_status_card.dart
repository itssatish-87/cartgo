import 'package:flutter/material.dart';

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          StatusItem(icon: Icons.payment, label: "Pending"),
          StatusItem(icon: Icons.local_shipping, label: "Shipped"),
          StatusItem(icon: Icons.check_circle, label: "Delivered"),
          StatusItem(icon: Icons.cancel, label: "Cancelled"),
        ],
      ),
    );
  }
}

class StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const StatusItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            debugPrint("Icon clicked");
          },
          icon: Icon(
            icon,
            color: Colors.deepPurple,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),

        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
