import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];
  List<Product> get cart => _cart;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartProvider() {
    _loadCart();
  }

  // Load cart items from Firestore
  void _loadCart() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .snapshots()
        .listen((snapshot) {
      _cart.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        _cart.add(Product(
          id: doc.id,
          name: data['name'],
          price: (data['price'] as num).toDouble(),
          imageUrl: data['imageUrl'],
        ));
      }
      notifyListeners();
    });
  }

  // Add product to cart
  Future<void> addToCart(Product product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final cartRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(product.id);

    final docSnapshot = await cartRef.get();
    if (docSnapshot.exists) {
      final currentQty = docSnapshot.data()?['quantity'] ?? 1;
      await cartRef.update({'quantity': currentQty + 1});
    } else {
      await cartRef.set({
        'name': product.name,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'quantity': 1,
      });
    }
  }

  // Remove product from cart
  Future<void> removeFromCart(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  double get totalPrice =>
      _cart.fold(0, (sum, item) => sum + item.price);

  void clearCart() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final cartRef = _firestore.collection('users').doc(user.uid).collection('cart');
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    _cart.clear();
    notifyListeners();
  }
}
