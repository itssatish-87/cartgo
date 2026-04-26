import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/model/product_model.dart';
import '../widget/grocery_category.dart';
import '../widget/grocery_product_grid.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {

  List<Product> allProducts = [];
  List<Product> groceryProducts = [];

  bool isLoading = true;

  String selectedCategory = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // 🔥 LOAD PRODUCTS
  Future<void> loadProducts() async {
    try {
      setState(() => isLoading = true);

      final res = await http.get(
        Uri.parse("http://10.0.2.2:5000/products"),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        allProducts =
            data.map<Product>((e) => Product.fromJson(e)).toList();

        applyFilters(); // 🔥 APPLY FILTER
      } else {
        print("API ERROR: ${res.statusCode}");
      }

    } catch (e) {
      print("Error: $e");
    }

    setState(() => isLoading = false);
  }

  // 🔥 FILTER LOGIC
  void applyFilters() {
    List<Product> temp = allProducts
        .where((p) => p.category.toLowerCase() == "grocery")
        .toList();

    // 🔥 CATEGORY FILTER
    if (selectedCategory != "All") {
      temp = temp.where((p) {
        return p.name
            .toLowerCase()
            .contains(selectedCategory.toLowerCase());
      }).toList();
    }

    // 🔍 SEARCH FILTER
    if (searchQuery.isNotEmpty) {
      temp = temp.where((p) =>
          p.name.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    setState(() {
      groceryProducts = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: loadProducts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10),

                // 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      applyFilters();
                    },
                    decoration: InputDecoration(
                      hintText: "Search groceries...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 🔥 CATEGORY LIST
                GroceryCategory(
                  onCategorySelected: (category) {
                    selectedCategory = category;
                    applyFilters();
                  },
                ),

                const SizedBox(height: 10),

                // 🎯 BANNER
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Fresh Deals 🥦",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🧾 TITLE
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Groceries",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 PRODUCTS GRID
                groceryProducts.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("No grocery items")),
                )
                    : GroceryProductGrid(
                  products: groceryProducts,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}