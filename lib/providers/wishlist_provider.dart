import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  List<Product> _wishlist = [];

  List<Product> get wishlist => _wishlist;

  void addToWishlist(Product product) {
    _wishlist.add(product);
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _wishlist.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((item) => item.id == productId);
  }

  List<Product> favoriteProducts(List<Product> allProducts) {
    return allProducts.where((product) => isInWishlist(product.id)).toList();
  }
}
