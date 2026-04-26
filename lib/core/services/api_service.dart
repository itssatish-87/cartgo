import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchProducts() async {
  final response = await http.get(
    Uri.parse("http://10.0.2.2:5000/products"),
  );

  print("GET STATUS: ${response.statusCode}");
  print("GET BODY: ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load products");
  }
}

Future<void> addProductApi(Map<String, dynamic> product) async {
  final response = await http.post(
    Uri.parse("http://10.0.2.2:5000/products"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(product),
  );

  print("POST STATUS: ${response.statusCode}");
  print("POST BODY: ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Product Added ✅");
  } else {
    print("Failed to add product ❌");
  }
}