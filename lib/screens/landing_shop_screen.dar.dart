import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import '../models/product.dart';

class LandingShopScreen extends StatefulWidget {
  LandingShopScreen({Key? key}) : super(key: key);

  @override
  State<LandingShopScreen> createState() => _LandingShopScreenState();
}

class _LandingShopScreenState extends State<LandingShopScreen> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture =
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products =
        Provider.of<ProductProvider>(context).products;

    return FutureBuilder(
      future: _productsFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with "Shop" title (no buttons)
                    Text(
                      'Shop',
                      style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Product Grid (read-only)
                    Expanded(
                      child: products.isEmpty
                          ? Center(child: Text('No products available.'))
                          : GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: products.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (ctx, i) =>
                            ProductTile(product: products[i]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
