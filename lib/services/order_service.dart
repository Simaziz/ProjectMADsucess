import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Checkout **all cart items**
  Future<void> checkout() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final cartRef = _firestore.collection('users').doc(user.uid).collection('cart');
    final ordersRef = _firestore.collection('users').doc(user.uid).collection('orders');

    final cartSnapshot = await cartRef.get();
    if (cartSnapshot.docs.isEmpty) throw Exception("Cart is empty");

    double total = 0;
    List<Map<String, dynamic>> items = [];

    for (var doc in cartSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final quantity = (data['quantity'] ?? 1) as int;
      final price = ((data['price'] ?? 0) as num).toDouble();

      total += price * quantity;

      items.add({
        'productId': doc.id,
        'name': data['name'] ?? '',
        'imageUrl': data['imageUrl'] ?? '',
        'price': price,
        'quantity': quantity,
      });
    }

    await ordersRef.add({
      'date': DateTime.now(),
      'total': total,
      'items': items,
      'status': 'pending',
    });

    // Clear cart
    for (var doc in cartSnapshot.docs) {
      await cartRef.doc(doc.id).delete();
    }
  }

  /// Checkout **selected cart items only**
  Future<void> checkoutSelectedItems(List<QueryDocumentSnapshot> selectedDocs) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final cartRef = _firestore.collection('users').doc(user.uid).collection('cart');
    final ordersRef = _firestore.collection('users').doc(user.uid).collection('orders');

    if (selectedDocs.isEmpty) throw Exception("No items selected for checkout");

    double total = 0;
    List<Map<String, dynamic>> items = [];

    for (var doc in selectedDocs) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final quantity = (data['quantity'] ?? 1) as int;
      final price = ((data['price'] ?? 0) as num).toDouble();

      total += price * quantity;

      items.add({
        'productId': doc.id,
        'name': data['name'] ?? '',
        'imageUrl': data['imageUrl'] ?? '',
        'price': price,
        'quantity': quantity,
      });

      // Remove item from cart after checkout
      await cartRef.doc(doc.id).delete();
    }

    await ordersRef.add({
      'date': DateTime.now(),
      'total': total,
      'items': items,
      'status': 'pending',
    });
  }
}
