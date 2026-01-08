import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("My Orders")),
        body: Center(child: Text("Please log in to view your orders")),
      );
    }

    final ordersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('date', descending: true);

    return Scaffold(
      appBar: AppBar(title: Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No orders yet"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (ctx, i) {
              final order = orders[i];
              final data = order.data() as Map<String, dynamic>? ?? {};

              final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
              final total = (data['total'] ?? 0) as num;
              final status = data['status'] ?? 'pending';
              final dateTimestamp = data['date'] as Timestamp?;
              final date = dateTimestamp?.toDate() ?? DateTime.now();

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ExpansionTile(
                  title: Text(
                    "Total: \$${total.toStringAsFixed(2)} - ${status.toUpperCase()}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Date: ${date.toLocal().toString().split('.')[0]}",
                  ),
                  children: items.map((item) {
                    final name = item['name'] ?? '';
                    final price = (item['price'] ?? 0) as num;
                    final quantity = (item['quantity'] ?? 1) as int;
                    final imageUrl = item['imageUrl'] ?? '';

                    return ListTile(
                      leading: imageUrl.isNotEmpty
                          ? Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) =>
                            Icon(Icons.image_not_supported),
                      )
                          : Icon(Icons.image_not_supported, size: 50),
                      title: Text(name),
                      subtitle: Text(
                          "Qty: $quantity | \$${(price * quantity).toStringAsFixed(2)}"),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
