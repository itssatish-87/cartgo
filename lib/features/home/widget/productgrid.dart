import 'package:flutter/material.dart';
import '../../../core/model/product_model.dart';
import '../widget/product_card.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final bool showFilter; // 🔥 NEW

  const ProductGrid({
    super.key,
    required this.products,
    this.showFilter = false, // default off
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {

  String selectedCategory = "All";
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products;
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;

      if (category == "All") {
        filteredProducts = widget.products;
      } else {
        filteredProducts = widget.products
            .where((p) => p.category == category)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final categories = ["All", "T-Shirt", "Shirt", "Shoes"];

    return Column(
      children: [

        // 🔥 ONLY SHOW IF TRUE
        if (widget.showFilter)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => filterProducts(cat),
                  ),
                );
              }).toList(),
            ),
          ),

        if (widget.showFilter)
          const SizedBox(height: 10),

        // 🔹 GRID
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredProducts.length,
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.95, // 🔥 IMPORTANT
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: filteredProducts[index]);
          },
        ),
      ],
    );
  }
}