import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../core/model/product_model.dart';

class AddProductMerchantScreen extends StatefulWidget {
  final String shopName;
  final Product? productData;

  const AddProductMerchantScreen({
    super.key,
    required this.shopName, this.productData,
  });

  @override
  State<AddProductMerchantScreen> createState() =>
      _AddProductMerchantScreenState();
}

class _AddProductMerchantScreenState
    extends State<AddProductMerchantScreen> {

  final nameController = TextEditingController();
  final priceController = TextEditingController();

  File? selectedImage;

  final picker = ImagePicker();

  String selectedCategory = "Fashion";
  String selectedGroceryCategory = "Fruits";

  final List<String> categories = [
    "Fashion",
    "Electronics",
    "Grocery", // 🔥 ADD THIS
  ];

  final List<String> groceryCategories = [
    "Fruits",
    "Vegetables",
    "Dairy",
    "Snacks",
    "Drinks",
  ];

  // 🔥 IMAGE PICK
  Future pickImage() async {
    final picked =
    await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  // 🔥 CLOUDINARY UPLOAD
  Future<String?> uploadImage(File file) async {
    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/dtczd17qm/image/upload");

    var request = http.MultipartRequest("POST", url);

    request.fields['upload_preset'] = 'gocart';

    request.files.add(
      await http.MultipartFile.fromPath('file', file.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final resData = await response.stream.bytesToString();
      final jsonData = jsonDecode(resData);
      return jsonData['secure_url'];
    }

    return null;
  }

  // 🔥 ADD PRODUCT
  Future addProduct() async {
    if (selectedImage == null) return;

    final imageUrl = await uploadImage(selectedImage!);

    final res = await http.post(
      Uri.parse("http://10.0.2.2:5000/add-product"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "price": double.parse(priceController.text),
        "image": imageUrl,
        "shopName": widget.shopName,

        // 🔥 MAIN CATEGORY
        "category": selectedCategory,

        // 🔥 SUB CATEGORY (ONLY FOR GROCERY)
        "subCategory":
        selectedCategory == "Grocery"
            ? selectedGroceryCategory
            : "",
      }),
    );

    print(res.body);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product Added")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [

              // 🔥 IMAGE
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: selectedImage == null
                      ? const Icon(Icons.add_a_photo)
                      : Image.file(selectedImage!, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: nameController,
                decoration:
                const InputDecoration(labelText: "Product Name"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: "Price"),
              ),

              const SizedBox(height: 10),

              // 🔥 MAIN CATEGORY
              DropdownButtonFormField(
                value: selectedCategory,
                items: categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration:
                const InputDecoration(labelText: "Category"),
              ),

              const SizedBox(height: 10),

              // 🔥 SHOW ONLY WHEN GROCERY SELECTED
              if (selectedCategory == "Grocery")
                DropdownButtonFormField(
                  value: selectedGroceryCategory,
                  items: groceryCategories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGroceryCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Grocery Category",
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: addProduct,
                child: const Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}