import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    _products = await ProductService().fetchProducts();
    print('Products loaded: ${_products.length}'); // debug
    notifyListeners();
  }
}
