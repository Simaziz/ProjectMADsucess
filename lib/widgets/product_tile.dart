// lib/widgets/product_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/product.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/login_screen.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final bool readOnly; // Disable buttons if true

  const ProductTile({
    Key? key,
    required this.product,
    this.readOnly = false,
  }) : super(key: key);

  void _requireLogin(BuildContext context) {
    // Show SnackBar and navigate to login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please login to continue")),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product image
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
            ),
          ),

          // Product name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Product price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("\$${product.price.toStringAsFixed(2)}"),
          ),

          // Buttons: only show if not read-only
          if (!readOnly)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Favorite button
                IconButton(
                  icon: Icon(
                    wishlistProvider.isInWishlist(product.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    if (user == null) {
                      _requireLogin(context);
                    } else {
                      if (wishlistProvider.isInWishlist(product.id)) {
                        wishlistProvider.removeFromWishlist(product.id);
                      } else {
                        wishlistProvider.addToWishlist(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('${product.name} added to wishlist'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  },
                ),

                // Add to cart button
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.blue),
                  onPressed: () {
                    if (user == null) {
                      _requireLogin(context);
                    } else {
                      cartProvider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
