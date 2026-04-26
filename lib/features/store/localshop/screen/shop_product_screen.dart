import 'dart:convert';
import 'package:cartgo/merchant/screen/add_product_merchant_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/model/product_model.dart';

class ShopProductScreen extends StatefulWidget {
  final String shopName;
  final String ownerEmail;

  const ShopProductScreen({
    super.key,
    required this.shopName,
    required this.ownerEmail,
  });

  @override
  State<ShopProductScreen> createState() => _ShopProductScreenState();
}

class _ShopProductScreenState extends State<ShopProductScreen> {

  List<Product> products = [];
  List<dynamic> rawProducts = []; // for Mongo _id
  bool isLoading = true;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    checkOwner();
    fetchProducts();
  }

  // 🔥 CHECK OWNER
  void checkOwner() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email") ?? "";

    if (email == widget.ownerEmail) {
      setState(() {
        isOwner = true;
      });
    }
  }

  // 🔥 FETCH PRODUCTS
  Future<void> fetchProducts() async {
    try {
      final res = await http.get(
        Uri.parse(
          "http://10.0.2.2:5000/products-by-shop/${widget.shopName}",
        ),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          rawProducts = data;
          products =
              data.map<Product>((e) => Product.fromJson(e)).toList();
          isLoading = false;
        });
      }

    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  // ❌ DELETE PRODUCT
  Future<void> deleteProduct(String id) async {
    await http.delete(
      Uri.parse("http://10.0.2.2:5000/delete-product/$id"),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product Deleted ❌")),
    );

    fetchProducts();
  }

  // ✏️ EDIT PRODUCT (FIXED)
  Future<void> editProduct(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductMerchantScreen(
          shopName: widget.shopName,
          productData: product, // ✅ FIXED
        ),
      ),
    );

    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchProducts,
          )
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text("No products"))
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {

          final product = products[index];
          final raw = rawProducts[index];

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

              trailing: isOwner
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ✏️ EDIT
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      editProduct(product); // ✅ FIXED
                    },
                  ),

                  // ❌ DELETE
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () {
                      deleteProduct(raw["_id"]);
                    },
                  ),
                ],
              )
                  : null,
            ),
          );
        },
      ),

      // ➕ ADD PRODUCT
      floatingActionButton: isOwner
          ? FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddProductMerchantScreen(
                shopName: widget.shopName,
              ),
            ),
          );

          fetchProducts();
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}