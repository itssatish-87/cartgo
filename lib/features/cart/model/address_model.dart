class Address {
  final String name;
  final String phone;
  final String address;

  Address({
    required this.name,
    required this.phone,
    required this.address,
  });

  // 🔥 ADD THIS FUNCTION
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "address": address,
    };
  }

  // 🔥 OPTIONAL (future use)
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
    );
  }
}