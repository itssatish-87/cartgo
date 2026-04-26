class Product {
  final String name;
  final double price;
  final String image;
  final String category;
  final double? rating;
  final String shopName;

  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    this.rating,
    required this.shopName,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? 'General',
      rating: (json['rating'] as num?)?.toDouble(),
      shopName: json['shopName'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "image": image,
      "category": category,
      "rating": rating,
      "shopName": shopName,
      "quantity": quantity,
    };
  }
}