class Shop {
  final String name;
  final String image;
  final String category;
  final String ownerEmail; // 🔥 ADD

  Shop({
    required this.name,
    required this.image,
    required this.category,
    required this.ownerEmail,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      ownerEmail: json["ownerEmail"] ?? "", // 🔥 ADD
    );
  }
}