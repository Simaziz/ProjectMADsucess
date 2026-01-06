import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductScreen extends StatelessWidget {
  final Product product;

  ProductScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)), // FIXED
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(product.imageUrl, height: 250, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              product.name, // FIXED
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}', // safer formatting
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
