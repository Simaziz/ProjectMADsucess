import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add product to user's cart
  Future<void> addToCart(Product product) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final cartRef = _firestore.collection('users').doc(uid).collection('cart');

    await cartRef.doc(product.id).set({
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'quantity': 1,
    });
  }

  // Get user's cart as a stream
  Stream<List<Product>> getCart() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    final cartRef = _firestore.collection('users').doc(uid).collection('cart');

    return cartRef.snapshots().map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return Product(
        id: data['id'],
        name: data['name'],
        price: (data['price'] as num).toDouble(),
        imageUrl: data['imageUrl'],
      );
    }).toList());
  }

  // Remove from cart
  Future<void> removeFromCart(String productId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final cartRef = _firestore.collection('users').doc(uid).collection('cart');
    await cartRef.doc(productId).delete();
  }
}
