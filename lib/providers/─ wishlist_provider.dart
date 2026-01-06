import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  final List<String> _productIds = [];

  List<String> get productIds => _productIds;

  void toggleFavorite(String productId) {
    if (_productIds.contains(productId)) {
      _productIds.remove(productId);
    } else {
      _productIds.add(productId);
    }
    notifyListeners();
  }
}
