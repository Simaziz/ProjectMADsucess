// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/order_service.dart';
import 'order_success_screen.dart'; // New screen

class CheckoutScreen extends StatelessWidget {
  final List<QueryDocumentSnapshot> selectedCartItems;

  const CheckoutScreen({Key? key, required this.selectedCartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = 0;

    for (var doc in selectedCartItems) {
      final price = (doc['price'] ?? 0).toDouble();
      final quantity = doc['quantity'] ?? 1;
      total += price * quantity;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selectedCartItems.length,
                itemBuilder: (ctx, i) {
                  final doc = selectedCartItems[i];
                  final quantity = doc['quantity'] ?? 1;
                  return ListTile(
                    leading: Image.network(
                      doc['imageUrl'] ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) =>
                          Icon(Icons.image_not_supported),
                    ),
                    title: Text(doc['name'] ?? ''),
                    subtitle: Text(
                        "Qty: $quantity | \$${((doc['price'] ?? 0) * quantity).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Total: \$${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Place the order
                  await OrderService().checkoutSelectedItems(selectedCartItems);

                  // Navigate to Order Success screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => OrderSuccessScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Checkout failed: $e")),
                  );
                }
              },
              child: Text("Place Order"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
