import 'package:flutter/material.dart';
import '../../../core/model/product_model.dart';
import '../../cart/screen/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final List<Product> allProducts;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.allProducts,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  int currentIndex = 0;
  bool isWishlisted = false;

  late List<Product> similarProducts;

  @override
  void initState() {
    super.initState();
    similarProducts = getSimilarProducts(); // ✅ only once
  }

  // 🔥 IMAGE LIST
  List<String> get images => [
    widget.product.image,
    widget.product.image,
    widget.product.image,
  ];

  // 🔥 FINAL SIMILAR LOGIC (100% SAFE)
  List<Product> getSimilarProducts() {
    List<Product> list = [];

    for (var p in widget.allProducts) {
      if (p.name != widget.product.name) {
        list.add(p);
      }
    }

    // 🔥 fallback (IMPORTANT)
    if (list.isEmpty) {
      list = widget.allProducts;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // 🔥 PRICE LOGIC
    double price = product.price.toDouble();
    double mrp = price * 1.3;

    int discountPercent =
    (((mrp - price) / mrp) * 100).round();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                isWishlisted = !isWishlisted;
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔥 IMAGE SLIDER
                  Stack(
                    children: [
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.white,
                              child: Image.network(
                                images[index],
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),

                      // 🔥 DOTS
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                                (index) => Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 4),
                              width: currentIndex == index ? 10 : 6,
                              height: currentIndex == index ? 10 : 6,
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.orange
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 🔥 DISCOUNT BADGE
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: Colors.red,
                          child: Text(
                            "$discountPercent% OFF",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 🔥 PRODUCT INFO
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          product.name,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Text(
                              "₹${product.price}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              "₹${mrp.toInt()}",
                              style: const TextStyle(
                                decoration:
                                TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              "$discountPercent% OFF",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: const [
                            Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            Icon(Icons.star_half,
                                color: Colors.orange, size: 18),
                            SizedBox(width: 5),
                            Text("(4.5)"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔥 DESCRIPTION
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product Description",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Best quality product available. Comfortable and stylish for daily use.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔥 YOU MAY ALSO LIKE (ALWAYS SHOW)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "You May Also Like",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarProducts.length,
                            itemBuilder: (context, index) {
                              final item = similarProducts[index];

                              return Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  elevation: 3,
                                  child: Column(
                                    children: [

                                      Expanded(
                                        child: Image.network(
                                          item.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),

                                      Padding(
                                        padding:
                                        const EdgeInsets.all(6),
                                        child: Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                      ),

                                      Text(
                                        "₹${item.price}",
                                        style: const TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // 🔥 BUTTONS
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                            content:
                            Text("Added to cart 🛒")),
                      );
                    },
                    child: const Text("Add to Cart"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CheckoutScreen(
                                products: [product],
                              ),
                        ),
                      );
                    },
                    child: const Text("Buy Now"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}