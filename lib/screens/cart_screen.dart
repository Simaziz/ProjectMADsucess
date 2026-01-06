import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: cart.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (ctx, i) {
          final Product product = cart[i];
          return ListTile(
            leading: Image.network(
              product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stackTrace) =>
                  Icon(Icons.image_not_supported),
            ),
            title: Text(product.name),
            subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cartProvider.removeFromCart(product.id);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: cart.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      )
          : null,
    );
  }
}
