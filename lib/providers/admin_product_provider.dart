import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class AdminProductProvider extends ChangeNotifier {
  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('products');

  List<Product> _products = [];
  List<Product> get products => _products;

  // Fetch all products
  Future<void> fetchProducts() async {
    final snapshot = await productsCollection.get();
    _products = snapshot.docs
        .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    notifyListeners();
  }

  // Add product
  Future<void> addProduct(Product product) async {
    final docRef = await productsCollection.add(product.toMap());
    _products.add(Product(
        id: docRef.id,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price));
    notifyListeners();
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    await productsCollection.doc(product.id).update(product.toMap());
    int index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    await productsCollection.doc(id).delete();
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
