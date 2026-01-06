import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/wishlist_provider.dart';

class WishlistScreen extends StatelessWidget {
  final List<Product> allProducts;

  WishlistScreen({required this.allProducts, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final favoriteProducts = wishlistProvider.favoriteProducts(allProducts);

    return Scaffold(
      appBar: AppBar(title: Text('My Wishlist')),
      body: favoriteProducts.isEmpty
          ? Center(child: Text('No favorites yet!'))
          : GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: favoriteProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) {
          final product = favoriteProducts[i];
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
                  child: Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("\$${product.price.toStringAsFixed(2)}"),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    wishlistProvider.removeFromWishlist(product.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
