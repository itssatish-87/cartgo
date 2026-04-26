import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/order_model.dart';

class OrderProvider extends ChangeNotifier {

  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  // 🔥 FETCH ORDERS (FINAL FIXED)
  Future<void> fetchOrders(String email) async {
    try {
      print("🔍 FETCH EMAIL: $email");

      final res = await http.get(
        Uri.parse("http://10.0.2.2:5000/orders?email=$email"),
      );

      print("📦 RESPONSE: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data is List) {
          _orders = data
              .map<OrderModel>((e) => OrderModel.fromJson(e))
              .toList();
        } else {
          _orders = [];
        }

        print("✅ ORDERS COUNT: ${_orders.length}");

        notifyListeners();
      } else {
        print("❌ Fetch Error: ${res.body}");
        _orders = [];
        notifyListeners();
      }

    } catch (e) {
      print("🔥 ERROR: $e");
      _orders = [];
      notifyListeners();
    }
  }

  // 🔥 OPTIONAL (UI actions)
  void cancelOrder(int index) {
    _orders[index].isCancelled = true;
    notifyListeners();
  }

  void returnOrder(int index) {
    _orders[index].isReturned = true;
    notifyListeners();
  }

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}