import 'package:flutter/material.dart';
import '../../../core/model/product_model.dart';

class SubscriptionProvider extends ChangeNotifier {
  final List<Product> _subs = [];

  List<Product> get subs => _subs;

  void addSubscription(Product product) {
    _subs.add(product);
    notifyListeners();
  }
  void removeSubscription(int index) {
    _subs.removeAt(index);
    notifyListeners();
  }
}