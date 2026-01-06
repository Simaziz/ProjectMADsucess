import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch products only once
    _productsFuture =
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;

    return FutureBuilder(
      future: _productsFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Shop App')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Shop App'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WishlistScreen(allProducts: products),
                      ),
                    );
                  },
                  icon: Icon(Icons.favorite),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CartScreen()),
                    );
                  },
                  icon: Icon(Icons.shopping_cart),
                ),
              ],
            ),
            body: products.isEmpty
                ? Center(child: Text('No products available.'))
                : GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (ctx, i) => ProductTile(product: products[i]),
            ),
          );
        }
      },
    );
  }
}
