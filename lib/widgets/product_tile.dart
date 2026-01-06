import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stackTrace) =>
                  Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("\$${product.price.toStringAsFixed(2)}"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.blue),
                onPressed: () {
                  cartProvider.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
