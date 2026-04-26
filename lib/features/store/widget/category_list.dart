import 'package:flutter/material.dart';

class CategoryIconList extends StatefulWidget {

  final Function(String)? onCategoryTap; // 🔥 callback

  const CategoryIconList({super.key, this.onCategoryTap});

  @override
  State<CategoryIconList> createState() => _CategoryIconListState();
}

class _CategoryIconListState extends State<CategoryIconList> {

  int selectedIndex = 0;

  final List<Map<String, Object>> categories = [
    {"icon": Icons.person, "title": "For You"},
    {"icon": Icons.shop, "title": "Local Shop"},
    {"icon": Icons.checkroom, "title": "Fashion"},
    {"icon": Icons.phone_android, "title": "Mobiles"},
    {"icon": Icons.brush, "title": "Beauty"},
    {"icon": Icons.laptop, "title": "Electronics"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {

          final bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });

              final title = categories[index]["title"] as String;

              debugPrint(title);

              // 🔥 PASS VALUE TO PARENT
              widget.onCategoryTap?.call(title);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [

                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      categories[index]["icon"] as IconData,
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    categories[index]["title"] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}