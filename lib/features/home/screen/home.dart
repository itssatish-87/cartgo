import 'package:flutter/material.dart';
import '../../../core/model/product_model.dart';
import '../../../core/services/api_service.dart';
import '../widget/home_header.dart';
import '../widget/banner_slider.dart';
import '../screen/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // 🔥 LOAD PRODUCTS
  void loadProducts() async {
    try {
      final data = await fetchProducts();

      setState(() {
        products = data.map((e) => Product.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // 🔥 AI PICK (SAFE)
  List<Product> get aiProducts {
    final shuffled = [...products]..shuffle();
    return shuffled.take(products.length >= 4 ? 4 : products.length).toList();
  }

  // 🔥 RECOMMENDED (SAFE)
  List<Product> get recommendedProducts {
    if (products.length >= 2) {
      return products.take(2).toList();
    }
    return products;
  }

  // 🔥 POPULAR (SAFE - NEVER EMPTY)
  List<Product> get popularProducts {
    if (products.length <= 2) return products;
    return products.skip(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async => loadProducts(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [

              HomeHeader(userName: widget.userName),

              const SizedBox(height: 10),
              const BannerSlider(),
              const SizedBox(height: 10),

              // 🔥 AI PICK
              if (aiProducts.isNotEmpty) ...[
                sectionTitle("AI Pick For You"),
                horizontalList(aiProducts),
              ],

              const SizedBox(height: 20),

              // 🔥 RECOMMENDED
              if (recommendedProducts.isNotEmpty) ...[
                sectionTitle("Recommended for you"),
                horizontalList(recommendedProducts),
              ],

              const SizedBox(height: 20),

              // 🔥 POPULAR
              if (popularProducts.isNotEmpty) ...[
                sectionTitle("Popular Products"),
                verticalList(popularProducts),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 TITLE
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  // 🔥 IMAGE FIX (NO CROP ISSUE)
  Widget productImage(String url) {
    return Container(
      color: Colors.white,
      child: Image.network(
        url.isNotEmpty ? url : "https://picsum.photos/300",
        width: double.infinity,
        fit: BoxFit.contain, // ✅ FIXED

        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },

        errorBuilder: (context, error, stackTrace) {
          return Image.network(
            "https://picsum.photos/300",
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  // 🔥 HORIZONTAL LIST
  Widget horizontalList(List<Product> list) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final product = list[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductDetailScreen(product: product, allProducts: products,),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(left: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: productImage(product.image),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "₹${product.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔥 VERTICAL LIST
  Widget verticalList(List<Product> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {

        final product = list[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductDetailScreen(product: product, allProducts: products,),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                    child: productImage(product.image),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    "₹${product.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}