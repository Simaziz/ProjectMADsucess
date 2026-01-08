import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/order_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Track selected items for checkout
  final Map<String, bool> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Your Cart")),
        body: Center(child: Text("Please log in to view your cart")),
      );
    }

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final cartDocs = snapshot.data!.docs;
          if (cartDocs.isEmpty) return Center(child: Text("Your cart is empty"));

          // Initialize _selectedItems for new items
          for (var doc in cartDocs) {
            _selectedItems.putIfAbsent(doc.id, () => false);
          }

          // Calculate total for selected items
          double total = 0;
          for (var doc in cartDocs) {
            final price = (doc['price'] ?? 0).toDouble();
            final quantity = doc['quantity'] ?? 1;
            if (_selectedItems[doc.id] == true) {
              total += price * quantity;
            }
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartDocs.length,
                  itemBuilder: (ctx, i) {
                    final doc = cartDocs[i];
                    int quantity = doc['quantity'] ?? 1;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Checkbox(
                          value: _selectedItems[doc.id] ?? false,
                          onChanged: (val) {
                            setState(() {
                              _selectedItems[doc.id] = val ?? false;
                            });
                          },
                        ),
                        title: Text(doc['name'] ?? ''),
                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (quantity > 1) {
                                  cartRef.doc(doc.id).update({'quantity': quantity - 1});
                                }
                              },
                            ),
                            Text(quantity.toString()),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                cartRef.doc(doc.id).update({'quantity': quantity + 1});
                              },
                            ),
                            SizedBox(width: 16),
                            Text(
                              "\$${((doc['price'] ?? 0) * quantity).toStringAsFixed(2)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cartRef.doc(doc.id).delete();
                            setState(() {
                              _selectedItems.remove(doc.id);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("\$${total.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: total > 0
                          ? () {
                        final selectedDocs = cartDocs
                            .where((doc) => _selectedItems[doc.id] == true)
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CheckoutScreen(selectedCartItems: selectedDocs),
                          ),
                        );
                      }
                          : null,
                      child: Text("Proceed to Checkout"),
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
