// lib/screens/landing_shop_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import '../models/product.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LandingShopScreen extends StatefulWidget {
  const LandingShopScreen({Key? key}) : super(key: key);

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
          return const Scaffold(
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
                    const Text(
                      'Shop',
                      style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: products.isEmpty
                          ? const Center(child: Text('No products available.'))
                          : GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: products.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (ctx, i) =>
                            ProductTile(product: products[i]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // LOGIN and REGISTER buttons for guests
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text('Login'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
