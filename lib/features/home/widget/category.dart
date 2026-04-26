import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int selectedIndex = 0;

  final List<String> categories = [
    "For You",
    "Fashion",
    "Mobiles",
    "Beauty",
    "Electronics",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [

          // 🔹 Horizontal Category List
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 300),
                          height: 3,
                          width: 30,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // 🔹 Product List Below
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.shopping_bag,
                      color: Colors.blue,
                    ),
                    title: Text(
                      "${categories[selectedIndex]} Item ${index + 1}",
                    ),
                    subtitle:
                    const Text("This is demo product description"),
                  ),
                );
              },
            ),
          ),
        ],
      );
  }
}
