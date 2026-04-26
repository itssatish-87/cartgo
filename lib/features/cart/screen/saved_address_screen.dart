import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/address_model.dart';
import 'add_address_screen.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {

  List<Address> addresses = [];

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list = prefs.getStringList("addresses") ?? [];

    setState(() {
      addresses =
          list.map((e) => Address.fromJson(jsonDecode(e))).toList();
    });
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list =
    addresses.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList("addresses", list);
  }

  // ❌ DELETE
  void deleteAddress(int index) async {
    addresses.removeAt(index);
    await saveToPrefs();

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address Deleted ❌")),
    );
  }

  // ✏️ EDIT
  void editAddress(int index) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddAddressScreen(
          address: addresses[index], // 🔥 pass old data
        ),
      ),
    );

    if (updated != null) {
      addresses[index] = updated;
      await saveToPrefs();
      setState(() {});
    }
  }

  // ➕ ADD
  void addAddress() async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddAddressScreen(),
      ),
    );

    if (newAddress != null) {
      addresses.add(newAddress);
      await saveToPrefs();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Addresses")),

      floatingActionButton: FloatingActionButton(
        onPressed: addAddress,
        child: const Icon(Icons.add),
      ),

      body: addresses.isEmpty
          ? const Center(child: Text("No address found"))
          : ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, index) {

          final a = addresses[index];

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            child: ListTile(

              title: Text(a.name),

              subtitle: Text("${a.phone}\n${a.address}"),

              isThreeLine: true,

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ✏️ EDIT
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => editAddress(index),
                  ),

                  // ❌ DELETE
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () => deleteAddress(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}