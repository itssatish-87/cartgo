import 'package:flutter/material.dart';

class GroceryCategory extends StatefulWidget {
  final Function(String) onCategorySelected;

  const GroceryCategory({super.key, required this.onCategorySelected});

  @override
  State<GroceryCategory> createState() => _GroceryCategoryState();
}

class _GroceryCategoryState extends State<GroceryCategory> {

  int selectedIndex = 0;

  final List<String> categories = [
    "All",
    "Milk",
    "Fruits",
    "Vegetables",
    "Snacks",
    "Drinks",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {

          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });

              widget.onCategorySelected(categories[index]); // 🔥 IMPORTANT
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.green
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}