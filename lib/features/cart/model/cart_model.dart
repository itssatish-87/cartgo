import 'package:flutter/material.dart';

import '../../../core/model/product_model.dart';


class CartModel extends ChangeNotifier {
  final List<Product> _cartItems = [];

  // 🔹 Get all items
  List<Product> get cartItems => _cartItems;

  // 🔥 ADD THIS (COUNT FIX)
  int get count => _cartItems.length;

  // 🔹 Add item
  void addToCart(Product product) {
    final index =
    _cartItems.indexWhere((item) => item.name == product.name);

    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(Product(
        name: product.name,
        price: product.price,
        image: product.image,
        category: product.category,
        rating: product.rating,
        shopName:product.shopName,
      ));
    }

    notifyListeners();
  }

  // 🔹 Remove item
  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // 🔹 Increase quantity
  void increaseQty(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  // 🔹 Decrease quantity
  void decreaseQty(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  // 🔹 Total price
  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}