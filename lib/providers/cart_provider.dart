import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];

  List<Product> get cart => _cart;

  // Add product to cart
  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    _cart.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  // Check if product is already in cart
  bool isInCart(String productId) {
    return _cart.any((p) => p.id == productId);
  }

  // Total price
  double get totalPrice {
    return _cart.fold(0, (sum, item) => sum + item.price);
  }

  // Clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
