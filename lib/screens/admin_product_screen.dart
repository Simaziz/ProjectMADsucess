// lib/screens/admin_product_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_product_provider.dart';
import '../providers/auth_provider.dart';
import '../models/product.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({Key? key}) : super(key: key);

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;
  String? _editingProductId; // null if adding new product

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _imageController = TextEditingController();

    Provider.of<AdminProductProvider>(context, listen: false).fetchProducts();
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _imageController.clear();
    _editingProductId = null;
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProductProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Product input form
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
                final image = _imageController.text.trim();

                if (name.isEmpty || image.isEmpty || price <= 0) return;

                if (_editingProductId == null) {
                  // Add new product
                  final product = Product(
                    id: '',
                    name: name,
                    price: price,
                    imageUrl: image,
                  );
                  await adminProvider.addProduct(product);
                } else {
                  // Update existing product
                  final product = Product(
                    id: _editingProductId!,
                    name: name,
                    price: price,
                    imageUrl: image,
                  );
                  await adminProvider.updateProduct(product);
                }

                _clearForm();
              },
              child: Text(_editingProductId == null ? 'Add Product' : 'Update Product'),
            ),
            const SizedBox(height: 20),

            // Products list
            Expanded(
              child: ListView.builder(
                itemCount: adminProvider.products.length,
                itemBuilder: (ctx, index) {
                  final product = adminProvider.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            // Populate form for editing
                            setState(() {
                              _editingProductId = product.id;
                              _nameController.text = product.name;
                              _priceController.text = product.price.toString();
                              _imageController.text = product.imageUrl;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await adminProvider.deleteProduct(product.id);
                            if (_editingProductId == product.id) _clearForm();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
