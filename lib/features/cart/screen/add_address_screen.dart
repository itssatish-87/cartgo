import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddAddressScreen extends StatefulWidget {

  final Address? address; // 🔥 for edit

  const AddAddressScreen({super.key, this.address});

  @override
  State<AddAddressScreen> createState() =>
      _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 🔥 PREFILL FOR EDIT
    if (widget.address != null) {
      nameController.text = widget.address!.name;
      phoneController.text = widget.address!.phone;
      addressController.text = widget.address!.address;
    }
  }

  void saveAddress() {
    final newAddress = Address(
      name: nameController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    Navigator.pop(context, newAddress); // 🔥 return data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null
            ? "Add Address"
            : "Edit Address"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
              ),
            ),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveAddress,
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}