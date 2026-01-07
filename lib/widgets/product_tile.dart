// lib/widgets/product_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final bool readOnly; // <--- NEW: disable buttons when true

  const ProductTile({
    Key? key,
    required this.product,
    this.readOnly = false, // default is false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

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
                    if (wishlistProvider.isInWishlist(product.id)) {
                      wishlistProvider.removeFromWishlist(product.id);
                    } else {
                      wishlistProvider.addToWishlist(product);
                    }
                  },
                ),

                // Add to cart button
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.blue),
                  onPressed: () {
                    cartProvider.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
