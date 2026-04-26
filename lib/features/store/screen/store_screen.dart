import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../localshop/model/shop_model.dart';
import '../localshop/screen/shop_product_screen.dart';
import '../widget/category_list.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {

  String selectedCategory = "For You";

  List products = [];
  List<Shop> localShops = [];

  bool isLoadingProducts = false;
  bool isLoadingShops = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // 🔥 FETCH PRODUCTS
  Future<void> fetchProducts() async {
    setState(() => isLoadingProducts = true);

    try {
      final res = await http.get(
        Uri.parse("http://10.0.2.2:5000/products"),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => products = data);
      }
    } catch (e) {
      print("Product Error: $e");
    }

    setState(() => isLoadingProducts = false);
  }

  // 🔥 FETCH SHOPS
  Future<void> fetchShops() async {
    setState(() => isLoadingShops = true);

    try {
      final res = await http.get(
        Uri.parse("http://10.0.2.2:5000/shops"),
      );

      final data = jsonDecode(res.body);

      setState(() {
        localShops =
            data.map<Shop>((e) => Shop.fromJson(e)).toList();
      });

    } catch (e) {
      print("Shop Error: $e");
    }

    setState(() => isLoadingShops = false);
  }

  @override
  Widget build(BuildContext context) {

    // 🔥 CATEGORY FILTER
    List filteredProducts;

    if (selectedCategory == "For You") {
      filteredProducts = products;
    } else {
      filteredProducts = products.where((p) {
        return p["category"]
            .toString()
            .toLowerCase()
            .contains(selectedCategory.toLowerCase());
      }).toList();
    }

    return Scaffold(
      body: Column(
        children: [

          const SizedBox(height: 30),

          // 🔥 CATEGORY
          CategoryIconList(
            onCategoryTap: (category) {
              setState(() => selectedCategory = category);

              if (category == "Local Shop") {
                fetchShops();
              } else {
                fetchProducts();
              }
            },
          ),

          const SizedBox(height: 10),

          // 🔥 BANNER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage("assets/images/default.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ================= LOCAL SHOP =================
          if (selectedCategory == "Local Shop")
            Expanded(
              child: isLoadingShops
                  ? const Center(child: CircularProgressIndicator())
                  : localShops.isEmpty
                  ? const Center(child: Text("No shops found"))
                  : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: localShops.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {

                  final shop = localShops[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopProductScreen(
                            shopName: shop.name,
                            ownerEmail: shop.ownerEmail,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: shop.image != null &&
                                  shop.image.startsWith("http")
                                  ? Image.network(
                                shop.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                                  : Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.store),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              shop.name,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),

                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              shop.category ?? "Local Shop",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // ================= PRODUCTS =================
          if (selectedCategory != "Local Shop")
            Expanded(
              child: isLoadingProducts
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: filteredProducts.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {

                  final product = filteredProducts[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Image.network(
                            product['image'],
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            product['name'],
                            maxLines: 1,
                          ),
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "₹${product['price']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}