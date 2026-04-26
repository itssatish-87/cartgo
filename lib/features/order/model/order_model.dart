class OrderModel {
  final String email;
  final String shopName;
  final List<dynamic> products;
  final double totalAmount;
  final Map<String, dynamic> address;
  final String status;
  bool isCancelled; // 🔥 ADD
  bool isReturned;  // 🔥 ADD

  OrderModel({
    required this.email,
    required this.shopName,
    required this.products,
    required this.totalAmount,
    required this.address,
    this.isCancelled = false, // 🔥 default
    this.isReturned = false, required this.status,  // 🔥 default
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      email: json["email"] ?? "",
      shopName: json["shopName"] ?? "",
      products: json["products"] ?? [],
      totalAmount: (json["totalAmount"] ?? 0).toDouble(),
      address: json["address"] is Map
          ? json["address"]
          : {"address": json["address"] ?? ""},
      isCancelled: json["isCancelled"] ?? false, // 🔥 ADD
      isReturned: json["isReturned"] ?? false,   // 🔥 ADD
      status: json["status"] ?? "Placed",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "shopName": shopName,
      "products": products,
      "totalAmount": totalAmount,
      "address": address,
      "isCancelled": isCancelled,
      "isReturned": isReturned,
    };
  }
}